newtopic ()
{
#NOTE: Topic name CANNOT contain double quotes "
# WITH SINGLE STRING ARG: argument = Topic name
# WITH TWO STRING ARGS: arg1 = Topic name, arg2 = Topic description
if [[ $1 == *"\""* ]]; then
  echo "error: double quotes are not allowed in topic name" >&2
  return 1;
else
  # the following line works on Fedora 26
  local topicName=$(echo "$1" | sed 's/[\$]/\\&/g' | sed "s/'/\\\'/g")
fi

if [ $# -eq 1 ] 
then
  mysql --defaults-file=~/.my.cnf -e "SET @author = SUBSTRING(CURRENT_USER(),1,LOCATE('@',CURRENT_USER(),1)-1);\
		      			SET @topicname='${topicName}';\
					INSERT INTO Topics (Author, TopicName) VALUES (@author, @topicname);"
  # display new topic stat if mysql query was succesful
  if [ $? -eq 0 ]; then 
    mysql --defaults-file=~/.my.cnf -e "SELECT TopicName AS 'New topic created', TopicID AS 'ID', Author, TopicDescription AS 'Description'\
					FROM Topics WHERE TopicName = '${topicName}'";
  else
    return 1;
  fi 
elif [ $# -eq 2 ]
then
  # if topic exists, only update description, if doesn't exist, create topic
  local tmp=$( mysql --defaults-file=~/.my.cnf -e "SELECT TopicName FROM Topics WHERE TopicName = '${topicName}';")
  if [[ -z $tmp ]]; 
  then
    mysql --defaults-file=~/.my.cnf -e "SET @author = SUBSTRING(CURRENT_USER(),1,LOCATE('@',CURRENT_USER(),1)-1);
		      			SET @topicname='${topicName}'; SET @topicdescr='${2}';
					INSERT INTO Topics (Author, TopicName, TopicDescription) VALUES (@author, @topicname, @topicdescr);" 
    # display new topic stat if mysql query was succesful
    if [ $? -eq 0 ]; then 
      mysql --defaults-file=~/.my.cnf -e "SELECT TopicName AS 'New topic created', TopicID AS 'ID', Author, TopicDescription\
					 AS 'Description' from Topics\
					WHERE TopicName = '${topicName}'";
    else
      echo "error: could not create new topic" >&2
      return 1;
    fi
  else
    mysql --defaults-file=~/.my.cnf -e "UPDATE Topics SET TopicDescription = '${2}' WHERE TopicName = '${topicName}';"
    # display new topic stat if mysql query was succesful
    if [ $? -eq 0 ]; then
      mysql --defaults-file=~/.my.cnf -e "SELECT TopicName AS 'New topic created', TopicID AS 'ID', Author, TopicDescription\
                                         AS 'Description' from Topics\
                                        WHERE TopicName = '${topicName}'";
    else
      echo "error: could not create new topic" >&2
      return 1;
    fi
  fi 
else
  echo "error: wrong number of arguments" >&2
  return 1;
fi
}
