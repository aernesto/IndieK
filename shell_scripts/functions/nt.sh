nt ()
{
# REMARKS/PB:
#  1. in the STRING argument, all characters ! and simple quotes ' and double quotes " and $ and \ must be escaped with \
if [ $# -gt 2 ]; then
  echo "error: too many arguments. Try no arg or single string arg or nt -a <single string>." >&2
  return 1;
elif [ $# -eq 0 ] #if no argument is passed
then
  # TO IMPROVE: If several users write simultaneously to the table, then the code 
  # below is not enough to return the ID of the last item modified by the Current user
  mysql --defaults-file=~/.my.cnf -e "SELECT ItemID AS 'Last modified Item', LastModifDate AS 'Modification date'\
					 FROM Items ORDER BY LastModifDate DESC LIMIT 1;"
elif [ $# -eq 2 ]  #if two args were passed
then
  # Check if the option "-a" was passed as first argument
  if [[ $1 == "-a" ]]
  then
    local STRING="$2";
    # TO IMPROVE: for multiuser write events to the db, pass the author name to the sql script
    mysql --defaults-file=~/.my.cnf -e "set @content='${STRING}';
					SET @lastitem=(SELECT ItemID FROM Items ORDER BY LastModifDate DESC LIMIT 1);
					UPDATE Items
					# the CHAR(10) corresponds to a newline character on UNIX. Probably need CHAR(13) on Windows...	
					SET Content = CONCAT(Content,CHAR(10),@content) 
					WHERE ItemID = @lastitem;
					SELECT ItemID AS 'New content added to item' FROM Items WHERE ItemID = @lastitem;"  
  #check whether a project name was passed after the <STRING> argument
  else
    echo "error: wrong syntax." >&2
    return 1;
  fi
else
  local STRING="$1";
  mysql --defaults-file=~/.my.cnf -e "SET @author = SUBSTRING(CURRENT_USER(),1,LOCATE('@',CURRENT_USER(),1)-1);\
					 SET @content='${STRING}';\
					INSERT INTO Items (Author, Content)\
					VALUES (@author,@content);\
					SELECT ItemID AS 'New item created'\
					 FROM Items ORDER BY CreationDate DESC LIMIT 1;"
fi
}
