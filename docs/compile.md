# Compile a LaTeX item -- `compile`
## Description
Compiles with shell command `pdflatex` an item which has the Latex field
set to 1 in the database.
## Syntax
`compile <item ID>`  
## Examples of use
```
compile 33
```
## Arguments
Single integer corresponding to existing LaTeX item ID.
## Outputs/actions
produces a `.png` image file in folder 
`$indiek_images/latex`. To check which folder this is, simply type the following: 
`echo $indiek_images`