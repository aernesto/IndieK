searchtopic ()
{
  #SYNTAX: searchtopic "<field> LIKE <pattern> | IN <list>"
    #field is a column name from the Topics table
    #pattern is a MYSQL pattern, e.g. \"%some string%\"
    #list is a MYSQL list of numbers, e.g. (22,44,56)
  if [ $# -ne 1 ]; then
    echo "error: function requires exactly one argument" >&2
    return 1;
  else
    local STRING="$1"
    echo 
    mysql --defaults-file=~/.my.cnf -e "SELECT TopicName, TopicDescription FROM Topics WHERE ${STRING}\G" | fold -w 78 -s
  fi
}
