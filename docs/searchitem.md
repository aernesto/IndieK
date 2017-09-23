[back to table of contents](/index.md)
# Search for an item -- `searchitem`
## Description
To search for items in the database.
## Syntax
`searchitem "<part of SQL statement following a WHERE clause>"`
## Examples of use
```
searchitem "Content LIKE \"% keyword %\""
```
or the following typed on a single line
```
searchitem "(Content LIKE \"% keyword1 %\") AND (Content LIKE \"% keyword2 %\")"
```
or
```
searchitem "ItemID IN (22,14,17)"
```
## Arguments
Double quotes must be escaped, as in example.
The `WHERE` clause is applied to the Table `Items`.