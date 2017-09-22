# allows user to delete single item from the database
deleteitem ()
{
    # define regular expression that recognizes an integer
    local re='^[1-9][0-9]*$'
    
    if [ $# -ne 1 ]; then
        printf "WRONG ARGUMENT:\nGive exactly one integer as argument, corresponding to the item you want to delete from the database '$current_db_name'\n" >&2
        return 1;
    elif [[ $1 =~ $re ]]; then
        # Check that given item ID exists
        local tmp2=$( mysql --defaults-file=~/.my.cnf -e "SELECT ItemID FROM Items WHERE ItemID = ${1};" )
        if [[ -z $tmp2 ]]; then
            echo "error: item $1 doesn't exist" >&2
            return 1;
        fi
        # the lines starting with DELETE do the following (one instruction per line):
        # 1. remove entries corresponding to relations between items
        # 2. remove entries corresponding to relation 'item in topic'
        # 3. remove entries corresponding to item itself
        local query="set @itemid=${1};\
                DELETE FROM item_relation_1 WHERE (ParentID = ${1} OR ChildID = ${1});\
                DELETE FROM TopicsElements WHERE ItemID = @itemid;\
                DELETE FROM Items WHERE ItemID = @itemid;"
        mysql --defaults-file=~/.my.cnf -e "${query}"
        printf "Item ${1} deleted from database '$current_db_name'\n"
    else
        echo "error: argument should be an existing item ID" >&2
        return 1;
    fi
}
