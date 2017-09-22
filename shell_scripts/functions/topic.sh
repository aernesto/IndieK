topic ()
{
# Copied from topic.sh, commit 65466dd
# THIS SCRIPT DOES NOT CREATE NEW PROJECTS

# TO IMPROVE: 
#     1. Feedback messages are not completely consistent. For instance, if item 
#     4 is already in one of the topics, the message that 4 got added still prompts...
#     possible solution is to move the if statement containing that prompt inside the 
#     preceding for loop... but this would prompt many feedback lines on the console...
#
#     2. I don't know how to use my syntax: read -ra <array name> <<< $(mysql...) 
#         while declaring the array as local

# a first argument --recurs sets the script in recurs mode and skips many checks

if [[ "$1" == "--recurs" ]]
then
  local items=${@:2:$(($#-2))}
#   echo "RECURSIVE CALL!"
#   echo "all args ="
#   echo "$@"
#   echo "items="
#   echo "$items"
  #for loop that extracts the last argument
  for lastArg; do 
    true;
  done
  local topicName="$lastArg"
#  echo "topic name:" $topicName

  # create array with topic IDs of all the supra topics of the argument topic
  local query="SET @topicid=(SELECT TopicID FROM Topics\
                WHERE TopicName=\"${topicName}\");\
                SELECT SupraTopicID FROM topic_relation_1\
                WHERE SubTopicID = @topicid;"
#   # unset array if already exists
#   if [ -z ${array_supratopics+x} ]; then
#     echo "array was set"
#     unset $array_supratopics
#   fi 
  local array_supratopics=()
  while read line
  do 
    array_supratopics+=("$line")
  done < <(mysql --defaults-file=~/.my.cnf -Nse "${query}")

  # if the list of supra topics is empty, only update current topic
  if [ ${#array_supratopics} -eq 0 ]; then
    # echo "array of supra topics empty"
    for argument in $items # this only loops over arguments before the last one
    do
      mysql --defaults-file=~/.my.cnf -e "SET @itemid=${argument}; SET @topicid = (SELECT TopicID FROM Topics\
                              WHERE TopicName=\"${topicName}\");\
                              INSERT INTO TopicsElements (TopicID, ItemID) VALUES (@topicid, @itemid);\
                              UPDATE Topics SET LastModifDate = CURRENT_TIMESTAMP WHERE TopicID = @topicid;"
    done
    # display added item number if mysql query was succesful
    if [ $? -eq 0 ]; then 
      echo "added items:" $items "to topic" $topicName; 
    else
      return 1;
    fi
  # if the list of supra topics is non-empty, call the script recursively on each supra topic and each item id
  else 
 #    echo "array of supra topics non-empty:"
 #    echo "${array_supratopics[@]}"
    for topic_id in "${array_supratopics[@]}"; do
      local supra_topic_name=$( mysql --defaults-file=~/.my.cnf -se "SELECT TopicName FROM Topics WHERE TopicID = ${topic_id};" )
  #    echo "supra topic: $supra_topic_name"
      # RECURSIVE CALL (the --recurs argument is already in argument list)
 #     echo "recursive call will happen here with arguments:"
 #     echo ${@:1:$(($#-1))} "$supra_topic_name"
      topic ${@:1:$(($#-1))} "$supra_topic_name";
    done
    # echo "filling in current topic"
    for argument in $items # this only loops over arguments before the last one
    do
      # echo "treating item" $argument
      mysql --defaults-file=~/.my.cnf -e "SET @itemid=${argument}; SET @topicid = (SELECT TopicID FROM Topics\
                              WHERE TopicName=\"${topicName}\");\
                              INSERT INTO TopicsElements (TopicID, ItemID) VALUES (@topicid, @itemid);\
                              UPDATE Topics SET LastModifDate = CURRENT_TIMESTAMP WHERE TopicID = @topicid;"
    done
    # display added item number if mysql query was succesful
    if [ $? -eq 0 ]; then 
      echo "added items:" $items "to topic" $topicName; 
    else
      return 1;
    fi
  fi
  unset array_supratopics
# If not in --recurs mode
else
  #with no arguments, lists existing topics with their description
  if [ $# -eq 0 ]
  then
    #list existing topics
    mysql --defaults-file=~/.my.cnf -t -e "SELECT Level AS 'lvl', TopicName AS 'Topic name', TopicDescription AS 'Description'\
             FROM Topics ORDER BY LastModifDate DESC, TopicName;" | less

  #with one argument, it must be a topic name
  #displays elements of topic
  elif [ $# -eq 1 ]
  then
    local tmp0=$( mysql --defaults-file=~/.my.cnf -e "SELECT TopicID FROM Topics WHERE TopicName = \"${1}\";" )
    if [[ -z $tmp0 ]]; then
      echo "error: No such topic exists" >&2
      return 1;
    else
    mysql --defaults-file=~/.my.cnf -Nsse "SET @topicname=\"${1}\";\
            SET @topicid = (SELECT TopicID FROM Topics WHERE TopicName = @topicname);\
            SELECT ItemID AS 'Items' FROM TopicsElements\
            WHERE TopicID = @topicid\
            ORDER BY ItemID;" 
    fi

  # if more than 1 argument are given:
  else
#    echo "Normal mode"
    #array of all arguments but last one:
    local items=${@:1:$(($#-1))}
    #for loop that extracts the last argument
    for lastArg; do 
      true;
    done
    # check that the last argument is an existing topic
    local topicName="$lastArg"
    istopic "$topicName"
    if [ $? -eq 1 ]; then  # I don't know if it is better to check '-ne 0'
        echo "Error: topic '${topicName}' doesn't exist" >&2
        return 1
    fi
      # the following is a dry run trough the argument lists to check that all args before topic name are ItemIDs
      for argument in $items # this only loops over arguments before the last one
      do
        if [[ $argument =~ ^[0-9]+$ ]]
        then
          local tmp2=$( mysql --defaults-file=~/.my.cnf -e "SELECT ItemID FROM Items WHERE ItemID = ${argument};" )
          if [[ -z $tmp2 ]]; then
            echo "error: item $argument doesn't exist" >&2
            return 1;
          fi
        else 
          echo "---$argument---"
          echo "error: wrong syntax. All arguments before topic name must be Item IDs" >&2
          return 1;
        fi
      done

      # create array with topic IDs of all the supra topics of the argument topic
      local query2="SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${topicName}\");\
                          SELECT SupraTopicID FROM topic_relation_1\
                          WHERE SubTopicID = @topicid;"
                          
#       # unset array if already exists
#       if [ -z ${array_supratopics+x} ]; then
#         echo "array was set"
#         unset $array_supratopics
#       fi 
      local array_supratopics=()
      while read line2
      do 
        array_supratopics+=("$line2")
      done < <(mysql --defaults-file=~/.my.cnf -Nse "${query2}")

      # if the list of supra topics is empty, only update current topic
      if [ ${#array_supratopics} -eq 0 ]; then
        for argument in $items # this only loops over arguments before the last one
        do
          mysql --defaults-file=~/.my.cnf -e "SET @itemid=${argument}; SET @topicid = (SELECT TopicID FROM Topics\
                                  WHERE TopicName=\"${topicName}\");\
                                  INSERT INTO TopicsElements (TopicID, ItemID) VALUES (@topicid, @itemid);\
                                  UPDATE Topics SET LastModifDate = CURRENT_TIMESTAMP WHERE TopicID = @topicid;"
        done
        # display added item number if mysql query was succesful
        if [ $? -eq 0 ]; then 
          echo "added items:" $items "to topic" $topicName; 
        else
          return 1;
        fi
      # if the list of supra topics is non-empty, call the script recursively on each supra topic and update current topic
      else 
      
#      echo "array of supra topics"
#      echo "${array_supratopics[@]}"
        for topic_id in "${array_supratopics[@]}"; do
          local supra_topic_name=$( mysql --defaults-file=~/.my.cnf -se "SELECT TopicName FROM Topics WHERE TopicID = ${topic_id};" )
          # RECURSIVE CALL
          topic --recurs $items "$supra_topic_name";
        done
        for argument in $items # this only loops over arguments before the last one
        do
          mysql --defaults-file=~/.my.cnf -e "SET @itemid=${argument}; SET @topicid = (SELECT TopicID FROM Topics\
                                  WHERE TopicName=\"${topicName}\");\
                                  INSERT INTO TopicsElements (TopicID, ItemID) VALUES (@topicid, @itemid);\
                                  UPDATE Topics SET LastModifDate = CURRENT_TIMESTAMP WHERE TopicID = @topicid;"
        done
        # display added item number if mysql query was succesful
        if [ $? -eq 0 ]; then 
          echo "added items:" $items "to topic" $topicName; 
        else
          return 1;
        fi
      fi
      unset array_supratopics
  fi
fi
# echo "exiting topic function"
}
