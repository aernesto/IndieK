searchitem ()
{
  #SYNTAX: searchitem "<field> LIKE <pattern> | IN <list>"
    #field is a column name from the Items table
    #pattern is a MYSQL pattern, e.g. \"%some string%\"
    #list is a MYSQL list of numbers, e.g. (22,44,56)
  if [ $# -ne 1 ]; then
    echo "error: function requires exactly one argument" >&2
    return 1;
  else
    local STRING="$1"
    mysql --defaults-file=~/.my.cnf -Nse "SELECT ItemID FROM Items WHERE ${STRING};" # | fold -w 78 -s
  fi
}
