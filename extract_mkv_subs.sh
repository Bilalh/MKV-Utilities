#!/bin/bash
# extracts all fonts from the specified mkvs
IFS=$'\x0a';
for i in $*; do
	echo "$i"
	#Subs=`MediaInfo "$i" | grep -A 1 Text | grep ID | head -n 1 | grep -oP "\d+"`
	Subs=`mkvmerge -i "$i" | grep 'subtitles' | grep -oP '(?<=Track ID )\d+'`
	Name=${i%.*}
	mkvextract tracks "$i" ${Subs}:${Name}.ssa
done
unset IFS

