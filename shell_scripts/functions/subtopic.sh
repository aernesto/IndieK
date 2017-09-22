subtopic ()
{
# copied from subtopic.sh, commit 920cb80
# SYNTAX: subtopic <parent topic name> <child topic name>

# DESCRIPTION: This script does the following:
#       1. check that there are exactly two arguments
#       2. check that each argument is the name of an existing project
#       3. check that <parent topic> IS NOT in the list of subtopics of <child topic> (To avoid loops)
#       4. check that <child topic> IS NOT already in the list of subtopics of <parent topic>
if [ $# -ne 2 ]; then
  echo "error: must be called with two arguments: <supra-topic> <subtopic>" >&2
  return 1;
else
  local parentTopic="$1"
  local parentLevel=$( mysql --defaults-file=~/.my.cnf -Nse "SELECT Level FROM Topics WHERE TopicName = \"${parentTopic}\";" )
  if [[ -z $parentLevel ]]; then
    echo "error with $parentTopic: No such topic exists" >&2
    return 1;
  fi
  local childTopic="$2"
  local childLevel=$( mysql --defaults-file=~/.my.cnf -Nse "SELECT Level FROM Topics WHERE TopicName = \"${childTopic}\";" )
  if [[ -z $childLevel ]]; then
    echo "error with $childTopic: No such topic exists" >&2
    return 1;
  fi
fi

# function isdesc definition
isdesc ()
{
  local ancestor="$1"
  local descendent="$2" 
  local lvl_desc="$3"
  # echo "called with arguments:" $ancestor $descendent $lvl_desc

  # loop over chilren of ancestor
  # create array with topic names of all the subtopics of the argument topic
  local query="SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${ancestor}\");\
                SELECT TopicName FROM Topics WHERE TopicID IN (SELECT SubTopicID\
                FROM topic_relation_1 WHERE SupraTopicID = @topicid);"
  local array_subtopics=()  # initialize
  while read line
  do 
    array_subtopics+=("$line")
  done < <(mysql --defaults-file=~/.my.cnf -Nse "${query}")
  
  # piping the previous select command through the following in order to escape spaces in topic name did not 
  # solve the problem: | sed 's/\ /\\\ /g'

  # if the list of subtopics is empty, return 0 
  if [ ${#array_subtopics} -eq 0 ]; then
    # echo "$ancestor has no subtopics"
    return 0;
  else
    # echo "$ancestor has subtopics" ${array_subtopics[@]} "which is a total of " ${#array_subtopics[@]}
    for topic_name in "${array_subtopics[@]}"; do
      #topic_name=$( echo $topic_name | sed 's/___/\ /g'); 
      local lvl_child=$(mysql --defaults-file=~/.my.cnf -Nse "SELECT Level FROM Topics WHERE TopicName=\"${topic_name}\"") 
      # echo "subtopic $topic_name has level" $lvl_child
      if (( lvl_child > lvl_desc )); then
        # echo "$lvl_child is greater than $lvl_desc"
        :
      elif [[ $topic_name == $descendent ]]; then
        # echo "found subtopic $topic_name as a match"
        return 1 && break;
      elif [ $lvl_child -eq $lvl_desc ]; then
        # echo "$topic_name and $descendent have same level"
        :
      else 
        # RECURSIVE CALL
        # echo "recursive call"
        isdesc "$topic_name" "$descendent" $lvl_desc
        if [[ $? == 1 ]]; then
          return 1 && break;
        fi
      fi
    done
  fi
  unset array_subtopics
}

# when <child level> is equal to or smaller than <parent level>, 
# we can be sure that <child> is not in the list of children of <parent>.
if (( $childLevel > $parentLevel )); then  # check that <child> is not already a child of <parent>
  isdesc "$parentTopic" "$childTopic" $childLevel
  if [[ $? == 1 ]]; then
    echo "error: $childTopic is already a descendent from $parentTopic" >&2 
    return 1;
  fi
elif (( $childLevel < $parentLevel )); then  # check that <parent> is not a child of <child>
  isdesc "$childTopic" "$parentTopic" $parentLevel
  if [[ $? == 1 ]]; then
    echo "error: $parentTopic is already a descendent from $childTopic. Loops forbidden." >&2 
    return 1;
  fi
fi

# if all tests are passed, insert the new subtopic relation 
mysql --defaults-file=~/.my.cnf -e "SET @parentTopic=(SELECT TopicID FROM Topics WHERE TopicName=\"${parentTopic}\");\
                    SET @childTopic=(SELECT TopicID FROM Topics WHERE TopicName=\"${childTopic}\");\
                    INSERT INTO topic_relation_1 (SupraTopicID, SubTopicID)\
                    VALUES (@parentTopic,@childTopic);"

# and update levels accordingly if success of previous step
if [[ $? == 0 ]]; then
  # function definition
  update_supra_sub_levels ()
  {
    local descendent="${1}" 
    local lvl_ance="${2}"
    local lvl_desc="${3}"
    # echo "called with arguments:" "$1" "$2" "$3" 
    if (( $lvl_desc > $lvl_ance )); then
      # echo "$lvl_desc is greater than $lvl_ance"
      :
    else
      # echo "$lvl_desc is smaller than or equal to $lvl_ance"
      mysql --defaults-file=~/.my.cnf -e "UPDATE Topics SET Level = ${lvl_ance} + 1\
                        WHERE TopicName = \"${descendent}\"" 
      # echo "Updated level of $descendent to " $(( $lvl_ance + 1 )) "?"
      # loop over chilren of descendent
      # create array with topic names of all the subtopics of the argument topic
      
      # the following paragraph got replaced by the function get_supratopics
#       local query2="SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${descendent}\");\
#                     SELECT TopicName FROM Topics WHERE TopicID IN (SELECT SubTopicID\
#                       FROM topic_relation_1 WHERE SupraTopicID = @topicid);"
#       local array_subtopics=()  # initialize
#       while read line
#       do 
#         array_subtopics+=("$line")
#       done < <(mysql --defaults-file=~/.my.cnf -Nse "${query2}")
    get_subtopics "${descendent}"
    # if the list of subtopics is empty, return 0 
      if [ ${#array_subtopics} -eq 0 ]; then
        # echo "$descendent has no subtopics"
        :
      else
        for topic_name in "${array_subtopics[@]}"; do
          #topic_name=$(echo $topic_name | sed 's/___/\ /g');
          local lvl_new_desc=$( mysql --defaults-file=~/.my.cnf -se "SELECT Level FROM Topics\
                                     WHERE TopicName = \"${topic_name}\"" )
          # recursive call to update levels of subtopics
          # echo "about to call recursively with new descendent" "$topic_name and" "with level" $lvl_new_desc
          update_supra_sub_levels "$topic_name" $(( $lvl_ance + 1 )) $lvl_new_desc
        done
      fi
      unset array_subtopics
    fi
  }

  update_supra_sub_levels "$childTopic" $parentLevel $childLevel
else
  echo "error: failed to insert new subtopic relation" >&2
  return 1;
fi

# Finally, all levels were successfully updated, add items from subtopic to supratopic (only the ones
  #not already in supra topic)
if [[ $? == 0 ]]; then
  local query3="SET @supratopicid = (\
      SELECT TopicID FROM Topics WHERE TopicName = \"${parentTopic}\");\
      SET @subtopicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${childTopic}\");\
      SELECT ItemID FROM TopicsElements WHERE TopicID = @subtopicid AND ItemID NOT IN (\
      SELECT ItemID FROM TopicsElements WHERE TopicID = @supratopicid);"
  local array_items=()  # initialize
  while read line
  do 
    array_items+=("$line")
  done < <(mysql --defaults-file=~/.my.cnf -Nse "${query3}")
  
  # if the list of items is empty, return 0 
  if [ ${#array_items} -eq 0 ]; then
    # echo "$ancestor has no subtopics"
    :
  else
    topic ${array_items[@]} "$parentTopic"
#    echo ${array_items[@]} "$parentTopic"
  fi
  unset array_items
else
  echo "error: failed to update levels" >&2
  return 1;
fi
}
