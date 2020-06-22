#!/bin/sh
cd tmp
for f in *.xlsx
do 
    echo "Processing $f file.."
    file_basename=$(basename $f);
    filename=$(echo $file_basename | cut -f 1 -d '.');
    libreoffice --headless --convert-to csv $f --outdir . 
    rm $filename.csv
done

