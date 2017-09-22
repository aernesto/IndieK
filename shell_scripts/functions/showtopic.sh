showtopic ()
{
mysql --defaults-file=~/.my.cnf -e "set @topicname='${1}';
			SELECT ItemID AS 'Item', Author, Content FROM Items 
			WHERE ItemID IN (
				SELECT ItemID FROM TopicsElements
				WHERE TopicID IN (
					SELECT TopicID FROM Topics
					WHERE TopicName = @topicname)) \G" | grep -v "\*\*\*\*"
}
