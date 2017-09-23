[back to table of contents](/index.md)
# notintopic -- restricts a list of items
## Description
Only outputs the items that _DO NOT_ belong to the topics given as arguments.  
**Warning**: This function can _only_ be used with Shell piping. See examples below.

## Syntax
`<searchitem output> | notintopic`  
or  
`<intopic output> | notintopic`  

## Examples of use
```
searchitem "Content LIKE \"%sigma%\"" | notintopic "proba" | showitem
```
OR
```
searchitem "Content LIKE \"%sigma%\"" | intopic "proba" | notintopic "phd" "algebra" | showitem
```
## Arguments
**Exclusively** a list of ItemIDs from stdin, such as the ones outputted from the `searchitem` and `intopic` functions.
## Outputs/actions
Returns a list of item id's to stdout.