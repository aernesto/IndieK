[back to table of contents](/index.md)
# Graph a topic -- `gr`
## Description
Produces a graph of the topic, using `GraphViz`, where nodes are the items belonging to the topic and edges are the directed links produced by the `sub` command. 
## Syntax
`gr "<topic name>"`
## Examples of use
```
gr "proba"
```

## Arguments
Topic name surrounded by double quotes.

## Outputs/actions
Produces a `.png` file in folder `$km_images/graphs/`.