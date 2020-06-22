#!/bin/sh
cd tmp;
counter=0;
for i in *; do
	counter=$((counter+1))
	echo "Current file id: $counter";
	extension="${i##*.}";
	md5=$(md5sum $i)
	# rename file with md5
	md5sum $i | awk '{print $2 $1}' | xargs mv -f;
	# rename with md5.extension
	mv $(echo $md5 | awk '{print $1}') $(echo $md5 | awk '{print $1}').$extension
done
