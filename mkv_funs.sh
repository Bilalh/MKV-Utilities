alias mm="mkvmerge"

function amkv () {
	if [ -n "${1}" ]
	then
		if [ -d ~/Desktop/joinMkv/ ]
		then 
			echo ""
		else
			mkdir -p ~/Desktop/joinMkv/
			mkdir -p ~/Desktop/joinMkv/fin/
			mkdir -p ~/Desktop/joinMkv/rfin/
		fi
		cd ~/Desktop/joinMkv/
		mkvextract tracks "${1}" 2:audio.aac
		mp4box -add "audio.aac" "${2}.m4a"
		mv "${2}.m4a" "rfin/${2}.m4a"
		rm audio.aac
		open rfin/
	else
		echo -e "Extract the aac audio from a mkv file
		Needs mp4box
		The directory ~/Desktop/joinMkv/ will created if it is not there
		The file will be in mkv format and in ~/Desktop/joinMkv/rfin/
		1 The location of the mkv file
		2 The name to use"
	fi
}

#go to join mkv folder
function gmkv () {
	cd ~/Desktop/joinMkv 
}

#Join mkv(s)
function jmkv () {
	if [ -d ~/Desktop/joinMkv/ ]
	then 
		echo ""
	else
		mkdir -p ~/Desktop/joinMkv/
		mkdir -p ~/Desktop/joinMkv/fin/
		mkdir -p ~/Desktop/joinMkv/rfin/
	fi
	cd ~/Desktop/joinMkv

	if [ -f o-00${1}.mkv ]
	then 
		cp  o-00${1}.mkv fin/n.mkv
		mv o-00${1}.mkv fin/o-00${1}.mkv
		if [[ -f fin/o-00${1}.mkv && -f fin/n.mkv ]] 
		then
			for i in *.mkv
				do
				mkvmerge -o fin/o.mkv fin/n.mkv +"$i"
				mv fin/o.mkv fin/n.mkv
			done
		else
			echo "Error in First part"
		fi
	else 
		echo -e "Enter a positive one digit Number The First file should be named o-00X.mkv all the other mkv files will join to it"
	fi
}

#Keep only ith part
function kmkv () {
	cd ~/Desktop/joinMkv
	if [[ -f o-00${1}.mkv || -n "${1}" ]] 
	then
		mv o-00${1}.mkv fin/k.mkv
		for i in *.mkv
			do
			rm ${i}
		done
	else
		echo -e "Keep only the ith part renamed as in /fin as k.mkv"
	fi
}

#Remove first part
function rfmkv () {
	if [ -f  ~/Desktop/joinMkv/o-001.mkv ]
	then
		rm ~/Desktop/joinMkv/o-001.mkv
	else
		echo "no file"
	fi
}

#Spilt a Spilt file
function simkv () {
	cd ~/Desktop/joinMkv
	if [[ -f o-00${1}.mkv || -n "${1}" ]] 
	then
		mv o-00${1}.mkv fin/i.mkv
		mkvmerge -o o.mkv fin/i.mkv --split $2 $3
	else
		echo -e "Split the ith joined file fin/o-00i.mkv into parts\n Output files in joinMkv as o-ooX.mkv where the ith part is renamed to i.mkv in /fin"
	fi
}

# Split a file in part 
function smkv () {
	if [ -n "${1}" ]
	then
		if [ -d ~/Desktop/joinMkv/ ]
		then 
			echo ""
		else
			mkdir -p ~/Desktop/joinMkv/
			mkdir -p ~/Desktop/joinMkv/fin/
			mkdir -p ~/Desktop/joinMkv/rfin/
		fi
		mkvmerge -o ~/Desktop/joinMkv/o.mkv "$1" --split $2 $3
	else
		echo -e "Used to Split mkv files
		1 should be the path of the file to split
		2 should be the split in the form 00:00:00
		3 can used to give extra mkvmerge options
		The file will be in mkv format and in ~/Desktop/joinMkv/ 
		and will named in the form o-001.mkv"

	fi
}

#Spilt a join file
function snmkv () {
	cd ~/Desktop/joinMkv
	if [[ -f fin/n.mkv || -n "${1}" ]] 
	then
		mv fin/n.mkv fin/m.mkv
		mkvmerge -o o.mkv fin/m.mkv --split $1 $2
	else
		echo -e "Split a joined file fin/n.mkv into parts\n Output files in joinMkv as o-ooX.mkv"
	fi
	cd $OLDPWD;
}

function tmkv () {
	if [[ -n "${1}" && -n "${2}" && -f "${1}" ]]
	then
		if [ -d ~/Desktop/joinMkv/ ]
		then 
			echo ""
		else
			mkdir -p ~/Desktop/joinMkv/
			mkdir -p ~/Desktop/joinMkv/fin/
			mkdir -p ~/Desktop/joinMkv/rfin/
		fi
		cd ~/Desktop/joinMkv
		mkvmerge -o f.mkv "${1}" --split ${2} --split-max-files 2
		mv f-001.mkv fin/f.mkv
		for i in *.mkv
			do
			rm "${i}"
		done
		if [[ -n "${3}" && -f fin/f.mkv ]]
		then
			mkvmerge -o s.mkv fin/f.mkv --split ${3} --split-max-files 2
			rm s-001.mkv
			rm fin/f.mkv
			if [ -n "${4}" ]
			then
				mv s-002.mkv "rfin/${4}.mkv"
			else
				mv s-002.mkv "rfin/s-002.mkv"
			fi
		else
			mv fin/f.mkv "rfin/s-002.mkv"
		fi

	else
		echo -e "Extract the section of video between two time
		Time are in the form hh:mm:ss
		1 The location of the file
		2 The End time of the section
		3 The Start time of the section
		4 The name the fine
	The directory ~/Desktop/joinMkv/ will created if it is not there
	The file will be in mkv format and in ~/Desktop/joinMkv/rfin/
	Only the first three arguments are needed to work but the 
	third can be omitted meaning it be start time will be 00:00:00, 
	if there  is no name provided it will he named s-002.mkv.
	Spaces in one's path can cause errors.
	"
	fi
	cd $OLDPWD;
}