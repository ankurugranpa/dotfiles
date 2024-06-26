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
	explorer.exe $(wslpath -w $1)
}
autoload -Uz open

function chrome {
	# open on chrome
	/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe $1
}
autoload -Uz chrome

function wincd {
	# move to args win path
	cd $(wslpath -u $1)
}

autoload -Uz wincd 

function envadd {
	# add path
	if [ -z "$1" ]; then
    		echo "An argument is required."
	else
		echo "export PATH=\$PATH:$1" >> ~/dotfiles/.zsh.d/env.zsh
	fi
}

autoload -Uz envadd 
