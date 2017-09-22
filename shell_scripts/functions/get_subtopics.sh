get_subtopics ()
{
# NOTE: sets a global variable array_subtopics
# Takes a single topic name as argument and fill in the array_supratopics

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
    SELECT TopicName FROM Topics WHERE TopicID IN (SELECT SubTopicID\
    FROM topic_relation_1 WHERE SupraTopicID = @topicid);"
    array_subtopics=()  # reinitialize array
    while read line
    do 
        array_subtopics+=("$line")
    done < <(mysql --defaults-file=~/.my.cnf -Nse "${query}")
}
