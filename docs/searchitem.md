[back to table of contents](/index.md)
# searchitem -- Search for an item
## Description
To search for items in the database.
## Syntax
`searchitem "<part of SQL statement following a WHERE clause>"`
## Examples of use
```
searchitem "Content LIKE \"% keyword %\"" | showitem
```
or
```
searchitem "(Content LIKE \"% keyword1 %\") AND (Content LIKE \"% keyword2 %\")" | showitem
```
or
```
searchitem "ItemID IN (22,14,17)" | showitem
```

Note the use of `showitem` at the end, to display the content of the returned items, as opposed to their mere item id.
## Arguments
Double quotes must be escaped, as in example.
The `WHERE` clause is applied to the Table `Items`.
## Output
Returns a list of item ID's to stdout.