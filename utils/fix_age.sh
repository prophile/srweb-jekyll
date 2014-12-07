#!/bin/bash
DIR=$1
NAME=$2
CWD=$(pwd)
cd $DIR
CORRECT_DATE=$(git log -n 1 --pretty=format:%ad --date=short $NAME)
cd $CWD
mv $NAME.md $CORRECT_DATE-$NAME.md

