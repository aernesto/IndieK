ntx ()
{
  # SYNTAX: ntx 
if [ $# -gt 0 ] #if arguments are passed
then
  echo "error: too many arguments." >&2
  return 1;
else  
  local content # local variable that will store the content of the temp file
  # function that queries user input via editor
  testScript ()
  {
  local temp=$(mktemp) || die "Can't create temp file"
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

  mysql --defaults-file=~/.my.cnf -e "SET @author = SUBSTRING(CURRENT_USER(),1,LOCATE('@',CURRENT_USER(),1)-1); \
SET @content=\"${polished_content}\"; \
INSERT INTO Items (Author, Latex, Content) \
VALUES (@author, 1, @content); \
SELECT ItemID AS 'New item created', CreationDate AS 'Creation date' FROM Items ORDER BY CreationDate DESC LIMIT 1;" 
fi
}
