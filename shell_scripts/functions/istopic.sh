istopic ()
{
    # WARNING: this function is case insensitive for topic name
    # Returns 0 if single argument is an existing topic TopicName
    # Returns 1 otherwise
    
    if [ $# -ne 1 ]; then
        echo "Error: requires single argument" >&2
        return 1
    fi
    
    local tmp=$( mysql --defaults-file=~/.my.cnf -e "SELECT TopicID FROM Topics WHERE TopicName = \"${1}\";" )
    if [[ -z $tmp ]]; then
        echo "Topic '${1}' not found" >&2
        return 1;
    else
        return 0
    fi
}
