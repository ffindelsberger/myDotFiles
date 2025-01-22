#! /bin/bash

# This Skript picks a random file from the given Path and sets it as the Wallpaper using feh

# pick a random file from the path in the first arg
get_random_image() {
	directory=$1
	random_file=$(ls "$directory" | sort -R | tail -1)
	echo "$directory/$random_file"
}

random_image="$(get_random_image $1)" 
echo "$random_image"

