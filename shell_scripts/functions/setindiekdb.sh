# the following bash function is part of IndieK
# it allows the user to change the database he/she wants to use

# SYNTAX: setindiekdb <db_name>
setindiekdb ()
{
    if [ "$1" ]; then
    update_indiek_env ()
    {
        echo "updating IndieK variables..."
        # CONSTANTS
        # on Debian, for now, only use fourth line as indiek_images="/home/share/.indiek/images"
        current_db_name=$( grep database ~/.my.cnf | sed 's/database=\(.*\)/\1/g' )
        indiek_base_folder="${HOME}/.indiek/$current_db_name"
        indiek_tmp="${HOME}/.indiek/tmp"
        indiek_images="$indiek_base_folder/images" 
        echo "done!"
    }
        if [ "$1" == "db_test_1" ]; then
            sed -i.bak 's/database=.*/database=db_test_1/g' ~/.my.cnf
            chmod 600 ~/.my.cnf.bak
            if [ $? -eq 0 ]; then
                echo "'~/.my.cnf' database set to 'db_test_1'"
                update_indiek_env
            else
                echo "db name replacement failed"
            fi
        elif [ "$1" == "true_data" ]; then
            sed -i.bak 's/database=.*/database=true_data/g' ~/.my.cnf
            chmod 600 ~/.my.cnf.bak
            if [ $? -eq 0 ]; then
                echo "'~/.my.cnf' database set to 'true_data'"
                update_indiek_env
            else
                echo "db name replacement failed"
            fi
        elif [ "$1" == "indiekdb" ]; then
            sed -i.bak 's/database=.*/database=indiekdb/g' ~/.my.cnf
            chmod 600 ~/.my.cnf.bak
            if [ $? -eq 0 ]; then
                echo "'~/.my.cnf' database set to 'indiekdb'"
                update_indiek_env
            else
                echo "db name replacement failed"
            fi
        else
            echo "wrong arguments"
        fi
    else
        echo "wrong arguments"
    fi
}
