#!/bin/bash
# Media Encoding 


#TODO check for types 
function mkv4 () {
	mkvvideoT "$1"
	mkvaudioT "$1"
	#Fps=`mkvinfo "$1" | awk '/[0-9.]\ fps/ { print $6 }' | awk -F\( '{ print $2 }' | tail -1`
	Fps=`MediaInfo "$1" | grep "Frame rate" | grep -oP "[\d.]+"`
	name=`echo ${1} | sed 's/.mkv//g'` #removes file ext
	if [ -e /tmp/temp.AVC ]; then mv /tmp/temp.AVC /tmp/temp.h264 ; fi
	MP4Box -add /tmp/temp.AAC -add /tmp/temp.h264 -fps $Fps "$name.mp4"
	mkvsub "$1"
}

function mkvspilt () {
	mkvvideo "$1"
	mkvaudio "$1"
}

function mkvvideo () {
	Type=`mediainfo "$1" | grep -A 2 'Video' | grep 'Format' | head -n 1 | grep -oP '(?<=:).*' | grep -oP '\w+'`
	Video=`MediaInfo "$1" | grep -A 1 Video | grep ID | grep -oP "\d+"`
	mkvextract tracks "$1" ${Video}:"${1%.*}.${Type}"
}

function mkvaudio () {
	Type=`mediainfo "$1" | grep -A 2 'Audio' | grep 'Format' | head -n 1 | grep -oP '(?<=:).*' | sed 's/MPEG Audio/mp3/g' | grep -oP '\w+'	`
	Audio=`MediaInfo "$1" | grep -A 1 Audio | grep ID | grep -oP "\d+"`
	mkvextract tracks "$1" ${Audio}:"${1%.*}.${Type}"
}


function mkvsub () {
	Subs=`MediaInfo "$1" | grep -A 1 Text | grep ID | head -n 1 | grep -oP "\d+"`
	Name=${2:-${1%.*}}
	mkvextract tracks "$1" ${Subs}:${Name}.ssa
}

function aac () {
	mp4box -add "$1" "${1%.*}.m4a"
}

function aac_to_mp3(){
	faad -o - "$1" | lame - "${1%.m4a}.mp3"
}

function make_mkv(){
	mkvmerge "$1" -o "${1%.*}.mkv"
}


function mp4get () {
	mp4box -single "${1}" "${2}"
}

function mp4audio(){
	Id=`MediaInfo "$1" | grep -A 1 Audio | grep ID | grep -oP "\d+"`
	mp4get "${Id}" "$1"
}

function mp4video(){
	Id=`MediaInfo "$1" | grep -A 1 Video | grep ID | grep -oP "\d+"`
	mp4get "${Id}" "$1"
}

function mkvaac () {
	mkvaudioT "$1"
	name=`echo ${1} | sed 's/\.mkv//g'` #removes file ext
	mp4box -add "/tmp/temp.aac" "${name}.m4a"
}

function mkvvideoT () {
	Type=`mediainfo "$1" | grep -A 2 'Video' | grep 'Format' | head -n 1 | grep -oP '(?<=:).*' | grep -oP '\w+'`
	Video=`MediaInfo "$1" | grep -A 1 Video | grep ID | grep -oP "\d+"`
	mkvextract tracks "$1" ${Video}:/tmp/temp.${Type}
}
function mkvaudioT () {
	Type=`mediainfo "$1" | grep -A 2 'Audio' | grep 'Format' | head -n 1 | grep -oP '(?<=:).*' | sed 's/MPEG Audio/mp3/g' | grep -oP '\w+'	`
	Audio=`MediaInfo "$1" | grep -A 1 Audio | grep ID | grep -oP "\d+"`
	mkvextract tracks "$1" ${Audio}:/tmp/temp.${Type}
}

function audiotrackid(){
	MediaInfo "$1" | grep -A 1 Audio | grep ID | grep -oP "\d+"	
}
function videotrackid(){
	MediaInfo "$1" | grep -A 1 Video | grep ID | grep -oP "\d+"	
}
function audiotypeS () {
	mediainfo "$1" | grep -A 2 'Audio' | grep 'Format' | head -n 1 | grep -oP '(?<=:).*' | grep -oP '\w+'
}
function audiotype () {
	mediainfo "$1" | grep -A 2 'Audio' | grep 'Format' | head -n 2
}
function videotypeS () {
	mediainfo "$1" | grep -A 2 'Video' | grep 'Format' | head -n 1 | grep -oP '(?<=:).*' | grep -oP '\w+'
}
function videotype () {
	mediainfo "$1" | grep -A 2 'Video' | grep 'Format' | head -n 2
}


function aacToMp3_old() {
	ffmpeg -i "$1" -acodec mp3 -ac 2 -ab 196608 "${1%.*}.mp3"
}

function trash () {
	if [ ! -d ".Trash" ]; then
		mkdir .Trash
	fi
	mv "$1" ".Trash/$1"
}


