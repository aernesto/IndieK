i ()
{
# TODO: integrate the functionality that counts the number of upstream and downstream levels, as well as the loops
# 		might have to use recursivity (cnt_lvl(cnt_lvl(cnt_lvl(...etc...))))
# i <INTEGER> AS ARGUMENT, RETURNS THE STATS OF THE tA.<INTEGER>.txt file, see STATS section below
# i --up <INTEGER>, RETURNS LIST AND STATS OF PARENTS ONLY
# i --down <INTEGER>, RETURNS LIST AND STATS OF CHILDREN ONLY
# i --all <INTEGER>, RETURNS LIST AND STATS OF BOTH PARENTS AND CHILDREN
# ----------------
# STATS OF A NODE
# ----------------
# 1. tA file number
#
# 2. author
#
# 3. total number of parents
#
# 4. total number of children
#
# 5. total number of up-stream levels
#
# 6. total number of down-stream levels
# (note that loops form a special case as fall in both categories of up-stream and down-stream)
#######
###
# PROBLEMS:
#	1. doesn't check whether the unique given argument is an integer falling in the range of existing tA files
#	2. uses head -n 20 to display, but what if a tA file has more than 20 lines?
###
# define regular expression that recognizes an integer
local re='^[1-9][0-9]*$'

# condition with no argument, should produce error
if [ $# -eq 0 ] || [ $# -gt 1 ] 
then
  echo "error: needs exactly one argument; <Item ID> or <Topic name>" >&2
  return 1
# condition with sole integer as argument, should check whether argument is valid
# PURE CONDITIONAL TESTED
elif [[ $1 =~ $re ]]
then
  # Check that given item ID exists
  local tmp2=$( mysql --defaults-file=~/.my.cnf -e "SELECT ItemID FROM Items WHERE ItemID = ${1};" )
  if [[ -z $tmp2 ]]; then
    echo "error: item $1 doesn't exist" >&2
    return 1;
  fi
  mysql --defaults-file=~/.my.cnf -e "set @node='${1}';\
	SELECT ItemID AS 'Item', Author, Latex, LastModifDate AS 'Last modified' FROM Items\
	WHERE ItemID = @node\G" | grep -v "\*\*\*\*\*"
  echo -n "      Parents: "
  local query0="SET @node='${1}';\
			SELECT ParentID FROM item_relation_1\
			WHERE ChildID = @node;"
  local parents=()  # initialize
  while read line
  do
    parents+=("$line")
  done < <(mysql --defaults-file=~/.my.cnf -Nse "${query0}")
  
  if [ ${#parents[@]} -eq 0 ]; then
    echo 'None'
  else
    for i in "${parents[@]}"; do
      echo -n $i' '
    done
    echo -n "Total="
    mysql --defaults-file=~/.my.cnf -Nse "SET @node='${1}';\
		SELECT COUNT(*) FROM item_relation_1\
		WHERE ChildID = @node;"
  fi
  unset parents
  echo -n "     Children: "
  local query1="SET @node='${1}';\
			SELECT ChildID FROM item_relation_1\
			WHERE ParentID = @node;"
  local children=()  # initialize
  while read line
  do
    children+=("$line")
  done < <(mysql --defaults-file=~/.my.cnf -Nse "${query1}")

  if [ ${#children[@]} -eq 0 ]; then
    echo 'None'
  else
    for i in "${children[@]}"; do
      echo -n $i' '
    done
    echo -n "Total="
    mysql --defaults-file=~/.my.cnf -Nse "SET @node='${1}';\
		SELECT COUNT(*) FROM item_relation_1\
		WHERE ParentID = @node;"
  fi
  unset children
  echo -n "    In topics: "
  mysql --defaults-file=~/.my.cnf -se "set @node='${1}';\
			SELECT TopicName FROM Topics WHERE TopicID IN (\
        		SELECT TopicID FROM TopicsElements WHERE ItemID = @node);" |
  paste -sd "|" -
 
  echo
# condition where argument is not an integer (assumes it is a topic name)
else
  local topicName="${1}";
  mysql --defaults-file=~/.my.cnf -e "SET @topicname = \"${topicName}\";\
	SELECT TopicName AS 'Topic name', TopicID AS 'Topic ID', Level,\
	 TopicDescription AS 'Description', Author, LastModifDate AS 'Last modified' FROM Topics\
			WHERE TopicName=@topicname\G" | grep -v "\*\*\*\*\*"
  # TOTAL NUMBER OF ITEMS IN TOPIC
  echo -n "  Total items: "
  mysql --defaults-file=~/.my.cnf -Nse "SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${topicName}\");
					SELECT COUNT(*) FROM TopicsElements WHERE TopicID = @topicid;"
  # SUPRA TOPICS
  echo -n "  Supratopics: "
  local query="SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName =\"${topicName}\");\
    SELECT TopicName FROM Topics WHERE TopicID IN (SELECT SupraTopicID FROM topic_relation_1 WHERE SubTopicID = @topicid);"
  local supratopics=()  # initialize
  while read line
  do
    supratopics+=("$line")
  done < <(mysql --defaults-file=~/.my.cnf -Nse "${query}")
  
  if [ ${#supratopics[@]} -eq 0 ]; then
    echo 'None'
  else
    for i in "${supratopics[@]}"; do
      #local topic_name=$(echo "$i" | sed 's/___/\ /g');
      echo -n "$i"' | '
    done
    echo -n "Total="
    # what is below is inefficient
    mysql --defaults-file=~/.my.cnf -Nse "SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${topicName}\");\
                SELECT COUNT(*) FROM topic_relation_1\
                WHERE SubTopicID = @topicid;"
  fi
  unset supratopics
  # SUBTOPICS
  echo -n "    Subtopics: "
  local query2="SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${topicName}\");\
                        SELECT TopicName FROM Topics WHERE TopicID IN (\
                        SELECT SubTopicID FROM topic_relation_1 WHERE SupraTopicID = @topicid);"
  local subtopics=()  # initialize
  while read line
  do
    subtopics+=("$line")
  done < <(mysql --defaults-file=~/.my.cnf -Nse "${query2}")
  
  if [ ${#subtopics[@]} -eq 0 ]; then
    echo 'None'
  else
    for i in "${subtopics[@]}"; do
      #local topic_name=$(echo "$i" | sed 's/___/\ /g');
      echo -n "$i"' | '
    done
    echo -n "Total="
    mysql --defaults-file=~/.my.cnf -Nse "SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${topicName}\");\
                SELECT COUNT(*) FROM topic_relation_1\
                WHERE SupraTopicID = @topicid;"
  fi
  unset subtopics
#  echo -n "  "
#  mysql --defaults-file=~/.my.cnf -e "SELECT TopicDescription AS 'Description' FROM Topics\
#				      WHERE TopicName = '${1}'\G" | grep -v "\*\*\*\*\*"
fi
}
