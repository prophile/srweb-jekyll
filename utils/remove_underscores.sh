#!/bin/bash
set -e
for f in *; do
    f_with_rice=$(echo "$f" | sed 's/_/-/g')
    if [ "$f" != "$f_with_rice" ]; then
        mv "$f" "$f_with_rice"
    fi
done

