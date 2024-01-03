#!/bin/bash

# check number of arguments
if [ $# != 1 ]; then
	echo "Usage: submit [FILE]"
	exit
fi
FILE="$1"
PATH_=$(pwd)/"$FILE"

# check if file exists
if ! [[ -f "$PATH_" || -d "$PATH_" ]]; then
	echo "File not found."
	echo "Usage: submit [FILE]"
	exit
fi

# check file size
file_size_kb=$(du -k "$PATH_" | cut -f1)
if (( $file_size_kb > 1000 )); then
	echo "File size $filesize_kb is too large. Please try again with a smaller file."
	exit
fi

# check file type
file_type=$(file --mime-type -b $PATH_)
if ! [[ "$file_type" == *"x-7z-compressed"* || "$file_type" == *"pdf"* 
	|| "$file_type" == *"directory"* ]]; then
	echo "Only pdf, 7z, or directories  can be submitted. Please try again."
	exit
fi

# check if file under same name has already been submitted
if [ -f "/submissions/$FILE" ]; then
	echo "Duplicate file already submitted. Please rename and try again."
else
	mv "$PATH_" /submissions
	chmod 600 /submissions/"$FILE"
	# make sure file was moved properly
	if [[ -f /submissions/"$FILE" || -d /submissions/"$FILE" ]]; then
		# set color variable
		green='\033[0;32m'
		clear='\033[0m'
		echo -e "͙⁺˚*•̩̩͙✩•̩̩͙*˚⁺‧͙⁺˚*•̩̩͙✩•̩̩͙  ${green}Submission complete!${clear} *˚⁺‧͙⁺˚*•̩̩͙✩•̩̩͙*˚⁺‧͙"
		echo "Thank you for completing this task. Your submission will be reviewed shortly."
		echo "Exiting shell..."
		kill -9 $PPID > /dev/null
	else
		echo "File not submitted. Please try again or contact the organization."
	fi
fi

