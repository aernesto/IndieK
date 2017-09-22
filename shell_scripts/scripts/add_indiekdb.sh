#!/bin/bash
# Script takes exactly 1 string argument. Exit 1 otherwise
if [ $# -ne 1 ]
then
    echo "Usage: No argument supplied" >&2
    return 1;
else
    if [ -z "$1" ]
    then
        # this is for the case of null string passed as argument
        echo "Usage: No argument supplied" >&2
        return 1;
    fi
fi

dbname=${1}
LINK_OR_DIR=${HOME}/.indiek/$dbname
if [ -d "$LINK_OR_DIR" ]; then 
    if [ -L "$LINK_OR_DIR" ]; then
        # It is a symlink!
        # Symbolic link specific commands go here.
        echo "A symlink with your dbname was found"
        echo "No action taken"
    else
        # It's a directory!
        # Directory command goes here.
        echo "A directory for your dbname was found"
        echo "No action taken"
    fi
else
    command mkdir $LINK_OR_DIR
    chmod 755 $LINK_OR_DIR 
    command mkdir $LINK_OR_DIR/graphs
    chmod 755 $LINK_OR_DIR/graphs
    command mkdir $LINK_OR_DIR/images
    chmod 755 $LINK_OR_DIR/images
    command mkdir $LINK_OR_DIR/images/graphs
    chmod 755 $LINK_OR_DIR/images/graphs
    command mkdir $LINK_OR_DIR/images/latex
    chmod 755 $LINK_OR_DIR/images/latex
fi
