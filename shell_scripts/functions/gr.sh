# PBwith next fcn gr: What to do with LaTeX docs?
#		for now I will compile them separately
gr ()
{
  # TO IMPROVE: Set appropriate permissions to created files for collective use:
  #   wrap_tmp.txt rw------- 600
  #   *.gv         rw-rw---- 660
  #   *.png        rw-rw---- 660
	if [ $# -ne 1 ]; then
		echo "error: needs exactly one argument, and it must be an existing topic name" >&2
  		return 1;
  	else
  		# check that topic name exists
		local tmp0=$( mysql --defaults-file=~/.my.cnf -e "SELECT TopicID FROM Topics WHERE TopicName = \"${1}\";" )
		if [[ -z $tmp0 ]]; then
		  	echo "error: No such topic exists" >&2
		  	return 1;
		else
            local query="SET @topicname=\"${1}\";\
                SET @topicid = (SELECT TopicID FROM Topics WHERE TopicName = \
                @topicname);\
                SELECT ItemID FROM TopicsElements\
                WHERE TopicID = @topicid\
                ORDER BY ItemID;"
            while read line
            do 
                items_array+=("$line")
            done < <(mysql --defaults-file=~/.my.cnf -Nse "${query}")
		
            #echo "DEBUG mysql querry:"
            #mysql --defaults-file=~/.my.cnf -Nse \
            #                    "SET @topicname=\"${1}\";\
			#					SET @topicid = (SELECT TopicID FROM Topics WHERE TopicName = \
            #                    @topicname);\
			#					SELECT ItemID FROM TopicsElements\
			#					WHERE TopicID = @topicid\
			#					ORDER BY ItemID;"
			#read -ra items_array <<< $( mysql --defaults-file=~/.my.cnf -Nse \
            #                    "SET @topicname=\"${1}\";\
			#					SET @topicid = (SELECT TopicID FROM Topics WHERE TopicName = \
            #                    @topicname);\
			#					SELECT ItemID FROM TopicsElements\
			#					WHERE TopicID = @topicid\
			#					ORDER BY ItemID;" )
			#if topic is empty, give feedback and exit
			if [ ${#items_array} -eq 0 ]; then
				echo "topic is empty"
				return 0;
			else
                #local indiek_images="${HOME}/.indiek/images"
				#create dot file (graphviz)
				local topic_name_nospace=$( echo "${1}" | sed 's/ /_/g' );
				local GRAPH_NAME=$indiek_base_folder/graphs/$topic_name_nospace.gv

				# INSERT ALL NODES FROM PROJECT FILE INTO GRAPH FILE
				echo "strict digraph graph1 {" > $GRAPH_NAME
				#the following line draws all the arrows from left to right instead of top to
				#down. Useful when many isolated items or for short depth graphs.
				#echo "rankdir=LR;" >> $GRAPH_NAME
				#the following line removes the border frame around the nodes. For heavy 
				#graphs, it is better to leave the frames on
				echo "node [shape=box];" >> $GRAPH_NAME

				#loop over items
#				echo "DEBUG: items_array = "
#				printf "%s\n" "${items_array[@]}"
				#echo "${items_array[@]}"
				for NODE_NUMBER in "${items_array[@]}"; do
					# BELOW CAN BE COMPOUNDED IN SINGLE MYSQL CALL IN SAME ARRAY
					read -ra stats_array <<< $( mysql --defaults-file=~/.my.cnf -se \
                        "SELECT Author,\
                        LastModifDate, Latex FROM Items WHERE ItemID = \
                        ${NODE_NUMBER};" )
					# extract item author 
					local AUTHOR="${stats_array[0]}";
					# extract file last modif date
					local modif_date="${stats_array[1]}";
					local latex="${stats_array[3]}";
                    unset stats_array

					# Check whether the item requires LaTeX compilation
					if [[ $latex == "0" ]]; then
#                        echo "debug string:"
#                        echo "found that item $NODE_NUMBER is not of Latex type"
#                        echo "no existing image for it is sought"
						# IMPROVE: the -n option for echo below might not be necessary...
						echo -n "$NODE_NUMBER [label=\"$modif_date  item:\N  \
by:$AUTHOR\n\l" >> $GRAPH_NAME
						# escape all double quotes characters in text before wrapping it
						mysql --defaults-file=~/.my.cnf -Nre "SELECT Content FROM Items \
                                                        WHERE ItemID = ${NODE_NUMBER};" | 
							fold -w 60 -s | 
							head | 
							sed 's/"/\\\\"/g' > $indiek_tmp/wrap_tmp.txt

						#possible substitute line that avoids auxiliary file:
						# mysql --defaults-file=~/.my.cnf -Nre "SELECT Content FROM Items 
						#WHERE ItemID = ${NODE_NUMBER};" | 
						# 	fold -w 60 -s | 
						# 	head | 
						# 	sed 's/"/\\\\"/g' |
						# 	sed 's/$/\\l/g' |
						# 	paste -sd "" >> $GRAPH_NAME

						local SEARCH_STRING="";
						while read ATOM
						do
						   SEARCH_STRING="$SEARCH_STRING\l $ATOM"
						done < $indiek_tmp/wrap_tmp.txt
				    	SEARCH_STRING=$(echo $SEARCH_STRING | cut -c 2-)
                        SEARCH_STRING=$(echo $SEARCH_STRING | cut -c 2-)
						echo -n "$SEARCH_STRING" >> $GRAPH_NAME
						# THINK ABOUT HOW TO SHOW WHETHER CONTENT IS LARGER THAN 10 LINES
						# if [[ $( wc -l ~/.indiek/tmp/wrap_tmp.txt ) > 10 ]]; then
						# echo -n "+" >> $GRAPH_NAME
						# fi
						echo "\"];" >> $GRAPH_NAME
					elif [ -f $indiek_images/img_item_$NODE_NUMBER.png ]; then
 #                       echo "debug string:"
 #                       echo "found that an image for item $NODE_NUMBER exists at"
 #                       echo "$indiek_images/img_item_$NODE_NUMBER.png"
						echo "$NODE_NUMBER [label=<<TABLE>" >> $GRAPH_NAME
     					echo "<TR><TD>$modif_date  item:\N  by:$AUTHOR</TD></TR>" >> \
                                                                            $GRAPH_NAME
     					echo "<TR><TD>\
<IMG SRC=\"$indiek_images/img_item_$NODE_NUMBER.png\"/>\
</TD></TR>" >> $GRAPH_NAME
     					echo "</TABLE>>];" >> $GRAPH_NAME
                    elif [ -f $indiek_images/latex/img_item_$NODE_NUMBER.png ]; then
#                        echo "debug string:"
#                        echo "found that an image for item $NODE_NUMBER exists at"
#                        echo "$indiek_images/latex/img_item_$NODE_NUMBER.png"
                        echo "$NODE_NUMBER [label=<<TABLE>" >> $GRAPH_NAME
                        echo "<TR><TD>$modif_date  item:\N  by:$AUTHOR</TD></TR>" >> \
                                                                            $GRAPH_NAME
                        echo "<TR><TD>\
<IMG SRC=\"$indiek_images/latex/img_item_$NODE_NUMBER.png\"/>\
</TD></TR>" >> $GRAPH_NAME
                        echo "</TABLE>>];" >> $GRAPH_NAME
					else #if no image file, insert text after folding it
						echo "$NODE_NUMBER [label=<<TABLE>" >> $GRAPH_NAME
					   	echo "<TR><TD>$modif_date  item:\N  by:$AUTHOR</TD></TR>" >> \
                                                                            $GRAPH_NAME
					   	echo "<TR><TD>uncompiled LaTeX</TD></TR>" >> $GRAPH_NAME
					   	echo "</TABLE>>];" >> $GRAPH_NAME
					fi
					# INSERT ALL RELEVANT RELATIONS FROM rel.1.txt FILE INTO GRAPH FILE
					mysql --defaults-file=~/.my.cnf -Nre "SELECT ParentID, \
                            ChildID FROM item_relation_1 WHERE\
                            ParentID = ${NODE_NUMBER} OR ChildID = \
                            ${NODE_NUMBER};" | 
  sed -n "s/^\([1-9][0-9]*\)$(printf '\t')\([1-9][0-9]*\)$/\1 -> \2;/pg" >> \
                                                                            $GRAPH_NAME
				done
				# remove duplicate lines in .gv file -- This might be too inefficient...
				uniq $GRAPH_NAME > $indiek_tmp/tmp2.txt
				command mv $indiek_tmp/tmp2.txt $GRAPH_NAME

				echo -n "}" >> $GRAPH_NAME
				##################

				# COMPILE .gv FILE and set proper permissions to .gv and .png file
                chmod 666 $GRAPH_NAME 
				dot -Tpng $GRAPH_NAME -o $indiek_images/graphs/$topic_name_nospace.png
                chmod 664 $indiek_images/graphs/$topic_name_nospace.png
			fi
            unset items_array
		fi
	fi
}
