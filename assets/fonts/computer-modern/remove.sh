#!/bin/sh

files=$(ls)
for f in $files 
do
    ext=$(echo "$f" | cut -d "." -f 2 )
    file=$(echo "$f" | cut -d "." -f 1 | cut -d "-" -f 1 )
    mv "$f" "$file.$ext"
done