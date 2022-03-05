#!/bin/bash
FILE=~/.zshrc
if [ -e $FILE ];then
	echo "fileexiset"
else
	echo "no"
fi
