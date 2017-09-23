[back to table of contents](/index.md)
# intopic -- restricts a list of items
## Description
Only outputs the items that belong to all the topics given as arguments.  
**Warning**: This function can _only_ be used with Shell piping. See examples below.

## Syntax
`<searchitem output> | intopic`  
or  
`<notintopic output> | intopic`  

## Examples of use
```
searchitem "Content LIKE \"%sigma%\"" | intopic "proba" | showitem
```
OR
```
searchitem "Content LIKE \"%sigma%\"" | notintopic "proba" | intopic "phd" "algebra" | showitem
```
## Arguments
**Exclusively** a list of ItemIDs from stdin, such as the ones outputted from the `searchitem` and `notintopic` functions.
## Outputs/actions
Returns a list of item id's to stdout.