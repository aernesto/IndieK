grt ()
{
# With no arguments, function returns .gv and .png for graph of all topics in database $current_db_name
# Otherwise: one of the following four options must be the first argument:
#   --up
#   --down
#   --all
#   --list
# 
# RETURNS: a .gv and .png file for a graph of topics
#
# Description of each option:
# --up :  upstream topics, including the one given as argument
#         requires 1 topic name argument
# --down :  downstream topics, including the one given as argument
#         requires 1 topic name argument
# --all :  upstream and downstream topics
#          requires 1 topic name argument
# --list :  only the topics given as arguments (accepts input from stdin)
#           requires at least 1 topic name argument
#
# EXTENSIONS: once other types of links than subtopic exist in the db, make them apparent in output graph

    # if no argument
    if [ $# -eq 0 ]; then
        # extract all topic IDs
        local topicsID_array=()
        while read line 
        do
            topicsID_array+=("$line")
        done < <(mysql --defaults-file=~/.my.cnf -Nse "SELECT TopicID FROM Topics;")
        #echo "DEBUG: topics are"
        #printf "%s\n" "${topicsID_array[@]}"
        #if selection is empty, give feedback and exit
        if [ ${#topicsID_array} -eq 0 ]; then
            echo "No topic exist in database"
            return 0;
        else
            #create dot file (graphviz)
            local GRAPH_NAME=$indiek_base_folder/graphs/topics_graph.gv
            # INSERT ALL NODES FROM TOPIC LIST INTO GRAPH FILE
            echo "strict digraph graph1 {" > $GRAPH_NAME
            echo "rankdir=LR;" >> $GRAPH_NAME
            #echo "node [shape=box];" >> $GRAPH_NAME

            for TOPIC in "${topicsID_array[@]}"; do
                read -ra stats_array <<< $( mysql --defaults-file=~/.my.cnf -se "SELECT Author, LastModifDate FROM Topics WHERE TopicID = ${TOPIC};" )
                # extract item author 
                local AUTHOR="${stats_array[0]}";
                # extract file last modif date
                local modif_date="${stats_array[1]}";
                local nitems=$(mysql --defaults-file=~/.my.cnf -se "SELECT COUNT(ItemID) FROM TopicsElements WHERE TopicID = ${TOPIC};")

                echo -n "$TOPIC [label=\"$modif_date  topic:\N  by:$AUTHOR\ntitle:" >> $GRAPH_NAME

                # escape all double quotes characters in text before wrapping it
                mysql --defaults-file=~/.my.cnf -Nre "SELECT TopicName FROM Topics WHERE TopicID = ${TOPIC};" >> $GRAPH_NAME
                echo -n " \#items:$nitems" >> $GRAPH_NAME
                echo -n "\n\l" >> $GRAPH_NAME
                mysql --defaults-file=~/.my.cnf -Nre "SELECT TopicDescription FROM Topics WHERE TopicID = ${TOPIC};" |
                            fold -w 60 -s | 
                            sed 's/$/\\l/g' |
                            paste -sd "\0" - >> $GRAPH_NAME
                echo "\"];" >> $GRAPH_NAME
                # INSERT ALL RELEVANT RELATIONS between topics INTO GRAPH FILE
                mysql --defaults-file=~/.my.cnf -Nre "SELECT SupraTopicID, SubTopicID FROM topic_relation_1 WHERE (SupraTopicID = ${TOPIC}) OR (SubTopicID = ${TOPIC});" | 
                    sed -n "s/^\([1-9][0-9]*\)$(printf '\t')\([1-9][0-9]*\)$/\1 -> \2;/pg" >> $GRAPH_NAME
                unset stats_array
            done
            # remove duplicate lines in .gv file -- This might be too inefficient...
            uniq $GRAPH_NAME > $indiek_tmp/tmp3.txt
            command mv $indiek_tmp/tmp3.txt $GRAPH_NAME

            echo -n "}" >> $GRAPH_NAME
            ##################

            # COMPILE .gv FILE
            chmod 666 $GRAPH_NAME
            dot -Tpng $GRAPH_NAME -o $indiek_images/graphs/topics_graph.png
            chmod 664 $indiek_images/graphs/topics_graph.png
        fi
        unset topicsID_array
        
    # elif option --up
    elif [[ "$1" == "--up" ]]; then
        if [ $# -ne 2 ]; then
            echo "Error: --up option requires exactly 1 extra argument" >&2
            return 1
        fi
        topicname="${2}"
        istopic "$topicname"
        if [ $? -eq 1 ]; then  # I don't know if it is better to check '-ne 0'
            echo "Error: topic '${topicname}' doesn't exist" >&2
            return 1
        fi
        
        # Create array 'array_supratopics' of upstream topics
        get_supratopics "$topicname"
        
    # elif option --down
    elif [[ "$1" == "--down" ]]; then
        if [ $# -ne 2 ]; then
            echo "Error: --down option requires exactly 1 extra argument" >&2
            return 1
        fi
        echo "you passed --down option"
    # elif option --all
    elif [[ "$1" == "--all" ]]; then
        if [ $# -ne 2 ]; then
            echo "Error: --all option requires exactly 1 extra argument" >&2
            return 1
        fi
        echo "you passed --all option"
    # elif option --list
    elif [[ "$1" == "--list" ]]; then
        if [ $# -eq 1 ]; then
            echo "Error: --list option requires extra arguments" >&2
            return 1
        fi
        echo "you passed --list option"
    # otherwise, error
    else
        echo "Error: wrong first argument" >&2
        return 1
    fi
}
