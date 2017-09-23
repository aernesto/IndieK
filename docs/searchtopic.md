[back to table of contents](/index.md)
# searchtopic -- Search for a topic
## Description
To search for a topic.
## Syntax
`searchtopic "<part of SQL statement following a WHERE clause>"`
## Examples of use
```
searchtopic "TopicDescription LIKE \"% keyword %\""
```
or the following typed on a single line
```
searchtopic "(TopicName LIKE \"% keyword1 %\") OR (TopicDescription LIKE \"% keyword2 %\")"
```
or
```
searchtopic "TopicID IN (22,14,17)"
```
## Arguments
Double quotes must be escaped, as in example.
The `WHERE` clause is applied to the Table `Topics`.
