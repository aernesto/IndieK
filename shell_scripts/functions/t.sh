t ()
{
if [ $# -eq 0 ] || [ $# -gt 1 ]; then
  echo "error: wrong number of arguments" >&2
  return 1;
else 
  local tmp=$( mysql --defaults-file=~/.my.cnf -e "SELECT ItemID FROM Items WHERE ItemID = '${1}' \G")
  if [[ -z $tmp ]]; then
    echo "error: No such item exists" >&2
    return 1;
  else
    mysql --defaults-file=~/.my.cnf -e "SELECT ItemID AS 'Item', Content FROM Items WHERE ItemID = '${1}' \G" | grep -v "\*\*\*\*\*"
  fi
fi 
}
