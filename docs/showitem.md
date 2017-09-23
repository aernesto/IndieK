[back to table of contents](/index.md)
# showitem -- Displays list of Items
## Description
Displays to stdout a list of piped items.  
**Warning**: This function can _only_ be used with Shell piping. See examples below.

## Syntax
`<searchitem output> | showitem`  
or  
`<intopic output> | showitem`  
or  
`<notintopic output> | showitem`  

## Examples of use
```
searchitem "Content LIKE \"%sigma%\"" | showitem
```
OR
```
searchitem "Content LIKE \"%sigma%\"" | intopic "proba" | notintopic "phd" "algebra" | showitem
```
## Arguments
**Exclusively** a list of ItemIDs from stdin, such as the ones outputted from the `searchitem`, `intopic` and `notintopic` functions.
## Outputs/actions
Lists the following fields content of the items given as argument:
- ItemID
- list of topics to which the Item belongs
- list of parent items
- list of children items