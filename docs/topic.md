[back to table of contents](/index.md)
# Add item to topic/explore topic -- `topic`
## Description
This function has several purposes:
- Without arguments, it lists all existing topics with their description and level. 
- With single topic name as argument, it lists all the item IDs contained in this topic
- With a list of item ID followed by a topic name, it adds all the listed items to the topic
## Syntax
`topic`  
OR
`topic "<topic name>"`  
OR
`topic <item ID 1> ... <item ID n> "<topic name>"`  

## Examples of use
```
topic
```
or
```
topic "proba"
```
or
```
topic 36 66 27 "proba"
```
## Arguments
Always remember to surround topic names with double quotes. Especially if they contain spaces.
Item IDs are simply separated by spaces.
## Outputs/actions
I suggest maniulate topics using unique IDs because "topic names" are not unique.  