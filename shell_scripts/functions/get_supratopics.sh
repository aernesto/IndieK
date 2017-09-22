get_supratopics ()
{
# NOTE: sets a global variable array_supratopics
# Takes a single topic name as argument and fill in the array_supratopics

# the following chunk would return the Error in both situations when the array does not exist, and when it exists but is empty
#     if [ -z ${array_supratopics+x} ]; then
#         echo "Error: array_supratopics doesn't exist" >&2
#         return 1
#     fi
    if [ $# -ne 1 ]; then
        echo "Error: Needs a topic name as single argument" >&2
        return 1
    fi
    local topicName="$1"
    istopic "$topicName"
    if [ $? -ne 0 ]; then  # should I check rather for '-eq 1' ?
        echo "Error: topic '${topicName}' doesn't exist" >&2
        return 1
    fi

    local query="SET @topicid=(SELECT TopicID FROM Topics WHERE TopicName=\"${topicName}\"); 
    SELECT TopicName FROM Topics WHERE TopicID IN (SELECT SupraTopicID\
    FROM topic_relation_1 WHERE SubTopicID = @topicid);"
    array_supratopics=()  # reinitialize array
    while read line
    do 
        array_supratopics+=("$line")
    done < <(mysql --defaults-file=~/.my.cnf -Nse "${query}")
}
