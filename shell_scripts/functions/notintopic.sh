# returns the ItemIDs received from stdin, after having removed
# the IDs matching the given topic names as arguments
notintopic ()
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
    
    mysql --defaults-file=~/.my.cnf -Nse "SELECT ItemID FROM Items \
    WHERE ItemID IN ${itemids} AND ItemID NOT IN (SELECT ItemID FROM TopicsElements \
    WHERE TopicID IN (SELECT TopicID FROM Topics WHERE TopicName IN (${topics})));"
}
