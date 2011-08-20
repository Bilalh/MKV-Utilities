#!/bin/bash
# extracts all fonts from the specifed mkvs
IFS=$'\x0a';
for i in $*; do
	echo $i
	ids=`mkvmerge -i "$i"  | grep -oP '(?<=Attachment ID )[0-9]+'`
	for id in $ids; do 
		mkvextract attachments "$i" $id
	done
done
unset IFS
