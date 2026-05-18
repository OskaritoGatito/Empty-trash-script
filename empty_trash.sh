#!/bin/bash

HOME_DIR=""

#Protection against running script with root permissions - if someone would try to run it with sudo
if [ -n "$SUDO_USER" ]; then
    HOME_DIR=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    HOME_DIR="$HOME"
fi

USR_DIR="$HOME_DIR/.local/share/Trash/files"

#Checking the variables - if the string is empty or there is no directory like that
if [ -z "$HOME_DIR" ] || [ ! -d "$USR_DIR" ]; then
	echo "Cannot find user path - aborting..."
	exit 1
fi

echo "Found User directory!"

#Get the number of subdiretectories
NUMBER_OF_SUBDIRECTORIES=$(find "$USR_DIR" -mindepth 1 -maxdepth 1| wc -l)

if [ "$NUMBER_OF_SUBDIRECTORIES" -gt 0 ]; then
    echo "Deleting $NUMBER_OF_SUBDIRECTORIES files in the trash directory.."
    rm -rf "${USR_DIR:?}"/*
else
    echo "The trash dir is empty"
fi
