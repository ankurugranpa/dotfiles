function venv {
	# activate venv 
	if [ -n "$VIRTUAL_ENV" ]; then
		deactivate
	else
		source venv/bin/activate
	fi
}
autoload -Uz venv


function word {
	# open word(msoffice) 
	"/mnt/c/Program Files/Microsoft Office/root/Office16/WINWORD.EXE" /t $1 &
}
autoload -Uz word

function web-dl {
	curl -b $WEBCLASS "$2"  -o "$1"
	echo "Save File: [$1]"
}

autoload -Uz web-dl 



function open {
	# open something(with default APP) on Windows
	explorer.exe $1
}
autoload -Uz open

function chrome {
	# open on chrome
	/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe $1
}
autoload -Uz chrome
