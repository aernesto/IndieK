[back to table of contents](/index.md)
# Subordinate a topic to another -- `subtopic`
## Description
Defines an existing topic as a subset of another topic. The 
included topic is called _subtopic_ and the containing
topic the _supratopic_.
## Syntax
`subtopic "<supratopic name>" "<subtopic name>"`
## Examples of use
```
subtopic "infer" "proba"
```
## Arguments
Two strings surrounded by double quotes and separated by single space.

## Bugs
When the subtopic contains items that already are in the
supratopic, MYSQL throws an error. But it is harmless, 
meaning that the function still works as such.