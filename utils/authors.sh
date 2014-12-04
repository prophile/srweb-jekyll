#!/bin/bash

git shortlog -sne | 
# Ignore BRAIN LOG-FEEDS
	grep -v BRIAN | 
	grep -v "fail@studentrobotics.org" | 
	cut -f 2 > AUTHORS

if [ "$1" == "-e" ]
then
	nano AUTHORS
fi
