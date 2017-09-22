intopic ()
{
    # TODO: introduce a check that something was piped
    # build list of ItemIDs from pipe
    local itemids="("$(paste -sd "," - </dev/stdin)")"
    # Build string of topic ItemIDs
    local topics=""
    for topic_name in "$@"
    do
        new_topic_name="\""$(echo -n "$topic_name" | sed 's/["\$]/\\&/g')"\""
        topics=$topics,$new_topic_name
    done
    #remove first comma
    topics=${topics#","}
    #echo "$topics"
    mysql --defaults-file=~/.my.cnf -Nse "SELECT DISTINCT ItemID FROM TopicsElements \
    WHERE TopicID IN (SELECT TopicID FROM Topics WHERE TopicName IN (${topics})) \
    AND ItemID IN ${itemids};"
}
