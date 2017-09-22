showitem ()
{
    # TODO: introduce a check that something was piped
    # build array of ItemIDs from pipe
    local itemids=()
    while read line
    do
        itemids+=($line)
    done </dev/stdin
    for item in "${itemids[@]}"
    do
        echo "     Item: $item"
        # display Item info part 1
#        mysql --defaults-file=~/.my.cnf -e "SELECT ItemID AS 'Item', Author, LastModifDate, Content FROM Items WHERE ItemID = ${item} \G" | grep -v "\*\*\*\*" | fold -w 78 -s | head -13



        # THE FOLLOWING WAS ORIGINALLY PASTED FROM i.sh IN COMMIT c71bc6c
        # I added some modifications to it
        
        echo -n "In topics: "
        mysql --defaults-file=~/.my.cnf -se "SELECT TopicName FROM Topics WHERE TopicID IN (SELECT TopicID FROM TopicsElements WHERE ItemID = ${item});" | paste -sd "|" -
        
        echo -n "  Parents: "
        local query0="SELECT ParentID FROM item_relation_1 WHERE ChildID = ${item};"
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
        mysql --defaults-file=~/.my.cnf -Nse "SELECT COUNT(*) FROM item_relation_1 WHERE ChildID = ${item};"
        fi
        unset parents
        
        echo -n " Children: "
        local query1="SELECT ChildID FROM item_relation_1\
            WHERE ParentID = ${item};"
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
            mysql --defaults-file=~/.my.cnf -Nse "SELECT COUNT(*) FROM item_relation_1 WHERE ParentID = ${item};"
        fi
        unset children
        
        echo # "  Content:"
        mysql --defaults-file=~/.my.cnf -Nsse "SELECT Content FROM Items WHERE ItemID = ${item} \G" | grep -v "\*\*\*\*" | fold -w 78 -s | head -13
        echo "------------------------------------------------------"
    done
}
