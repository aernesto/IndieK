[back to table of contents](/index.md)
# Insert new text -- `nt`
## Description
Inserts a new 'idea' into IndieK's database. A simple text in
IndieK is called an _item_.
## Syntax
```nt "some string"```  
OR  
```nt -a "some string"```
## Examples of use
```
nt "my new idea"
```
or
```
nt "my new idea  
split across two lines"
```
or
```
nt -a "adding this as a new line to last created item"
```
## Arguments
Single string surrounded by double quotes.
## Bugs
All Shell special characters such as # ! ' " ? need to be escaped by a backward
slash \
