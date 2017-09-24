[back to table of contents](/index.md)
# setindiekdb -- Change IndieK database
## Description
Changes the default MySQL database used by IndieK. Note that the database and
its tables must already be created in MySQL, and the database name must be
added to the setindiekdb.sh script as explained in this [video](https://youtu.be/olD3a2kixUU).
## Syntax
`setindiekdb "<database name>"`
## Examples of use
```
setindiekdb "db_test"
```

## Arguments
A MySQL database name surrounded by double quotes. 

**REQUIREMENTS:** 
- You, as a MySQL user, must
have reading and writing permissions to this database.   
- The database
tables from IndieK, as described in [this script](https://github.com/aernesto/IndieK/blob/master/SQL_scripts/SQL_TABLES_CREATION.sql), 
must exist.  
- The IndieK's hidden folders for the new database must exist. For this,
  execute [this script](https://github.com/aernesto/IndieK/blob/master/shell_scripts/scripts/add_indiekdb.sh) 
  with the database name passed as argument, on your computer.

## Outputs/actions
Writes the correct database name to the ~/.my.cnf file, and changes IndieK's
internal variables.
