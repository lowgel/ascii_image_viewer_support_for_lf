#!/bin/sh
#
#
#checks if the file is an image
if [[ "$( file -Lb --mime-type "$1")" =~ ^image ]]; then

#gets dimensions of image
	str=$(exiv2 $1 | grep -o "\S*\sx\s[0-9]*")
	#echo "$str"
	w="${str%% *}"
	h="${str##[0-9]* x }"

#resizes image. the width value is hard coded here, if you want bigger images, change new_w
	ratio=$(echo "scale=2 ; $w / $h" | bc)
	#echo "$ratio"
	new_w=60
	#echo "$new_w"
	new_h=$(printf "%.0f" "$(bc <<< "scale=0; $new_w/$ratio/2")")
	#echo "$new_h"

#converts image
	echo $str 
	ascii-image-converter -C  -d $new_w,$new_h $1
	exit 1

#if file is not an image, display contents
else
	cat "$1"
fi
