edititem ()
{
  #version 1 of this function, doesn't use LOAD_INFILE() from mysql
  #syntax: edititem <item id>
    if [ $# -ne 1 ]; then
      echo "error: requires a single item id integer as argument" >&2
      return 1;
    elif [ -z "$1" ]; then # zero length parameter
      echo "error: requires a single item id integer as argument" >&2
      return 1;
    elif [[ -n ${1//[0-9]/} ]] ; then # parameter contains non-integers
      echo "error: requires a single item id integer as argument" >&2
    else #now check item id exists in db
      local itemid=$1
      local tmp=$( mysql --defaults-file=~/.my.cnf -e "SELECT ItemID FROM Items WHERE ItemID = ${1} \G")
      if [[ -z $tmp ]]; then
        echo "error: No such item exists" >&2
        return 1;
      else
        local content # local variable that will store the content of the temp file
      # function that queries user input via editor
      testScript ()
      {
      local temp=$(mktemp) || die "Can't create temp file"
      # fill in file with current item content
#      echo "supposedly querying the following"
#      echo "arg = $itemid"
#      mysql --defaults-file=~/.my.cnf -Nre "SELECT Content FROM Items WHERE ItemID = ${itemid};"
      mysql --defaults-file=~/.my.cnf -Nre "SELECT Content FROM Items WHERE ItemID = ${itemid};" >> "$temp"

      local ret_code
      if "$EDITOR" -- "$temp" && [[ -s $temp ]]; then
          # slurp file content in variable content, deleting trailing blank lines
          content=$(< "$temp")
          ret_code=0
      else
          ret_code=1
      fi
      rm -f -- "$temp"
      return "$ret_code"
      }
      # request user input via EDITOR
      testScript || die "There was an error when querying user input"

      # the following is meant to escape the necessary characters in MYSQL "\$'

      # the following line works on OS X "El Capitan"
      #local polished_content=$(echo "$content" | sed 's/["\$]/\\&/g' | sed "s/\'/\\\'/g")
      
      # the following line works on Fedora 26
      local polished_content=$(echo "$content" | sed 's/["\$]/\\&/g' | sed "s/'/\\\'/g")

#      echo "$polished_content"
      mysql --defaults-file=~/.my.cnf -e "UPDATE Items SET Content = \"${polished_content}\" WHERE ItemID = ${itemid};"
    fi
  fi
}
