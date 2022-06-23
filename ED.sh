#!/bin/bash
FILEPATH=$1
FPATH=$2
cat $FILEPATH>>$FPATH
cat -n $FPATH

