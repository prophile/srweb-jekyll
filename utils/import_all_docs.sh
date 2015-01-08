#!/bin/bash
set -e
OUTPUT_DIR=`pwd`/docs
PYTHON_UTIL=`pwd`/utils/import_srweb.py
DOCS_DIR=$1
cd $DOCS_DIR
find . -not -name '.*' -type d | cut -c3- | xargs -I @ mkdir -p $OUTPUT_DIR/@
find . -not -name '.*' -type f | grep -v 'troubleshooter' | cut -c3- | xargs -I @ python3 $PYTHON_UTIL -s -l docs @ -o $OUTPUT_DIR/@.md

