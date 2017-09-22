#TODO: forbid the possibility of a relation from an item to itself
sub ()
{
#NOTE: DOESN'T ACCEPT 3 or more arguments
# regular expression meaning two integers, separated by white space
local re='^\s*[0-9]+ [0-9]+\s*$'

# reg exp meaning : an integer
local re2='^[0-9]+$'

# return if 0 or >2 args
if [ $# -eq 0 ] || [ $# -gt 2 ]; then
  return 1;

# if the argument is exactly 2 integers.
elif [[ $* =~ $re ]]; then 
  local PARENT=$1
  local CHILD=$2
# 
# # if the first argument is an integer
# elif [[ $1 =~ $re2 ]]; then
#   local PARENT=$1
#   local lastnum=$( mysql --defaults-file=~/.my.cnf -e "SELECT ItemID AS 'Last modified Item', LastModifDate AS 'Modification date'\
#  						 FROM Items ORDER BY LastModifDate DESC LIMIT 1;" | tail -1 | cut -f1 )
#   local CHILD=$(expr $lastnum + "1")
#   local STRING="$2"
# 
#   # call nt 
#   nt "$STRING"
# 
# # if script called with single STRING argument
# else
#   # creates number of the newly created tA file
#   local PARENT=$( mysql --defaults-file=~/.my.cnf -e "SELECT ItemID AS 'Last modified Item', LastModifDate AS 'Modification date'\
#  						FROM Items ORDER BY LastModifDate DESC LIMIT 1;" | tail -1 | cut -f1 )
#   local CHILD=$(expr $PARENT + "1")
#   local STRING="$1"
# 
#   # call nt with remaining argument
#   nt "$STRING"
fi

# Add the newly created PARENT-CHILD pair to the relations file: rel.1.txt
mysql --defaults-file=~/.my.cnf -e "SET @id1='${PARENT}'; SET @id2='${CHILD}';
				    INSERT INTO item_relation_1 (ParentID, ChildID) VALUES (@id1, @id2);"
# display added item number if mysql query was succesful
if [ $? -eq 0 ]; then 
  echo "added item relation:" $PARENT "-->" $CHILD;
else
  echo "error: failed to insert new relation" >&2
  return 1;
fi 
}
