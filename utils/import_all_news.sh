#!/bin/bash
set -e
OUTPUT_DIR=`pwd`/_posts
PYTHON_UTIL=`pwd`/utils/import_srweb.py
NEWS_DIR=$1
cd $NEWS_DIR
find . -not -name '.*' -type f | cut -c3- | xargs -I @ python3 $PYTHON_UTIL -s -l news @ -o $OUTPUT_DIR/@.md

