function venv {
	# activate venv 
	source venv/bin/activate
}
autoload -Uz venv


function word {
	# open word(msoffice) 
	"/mnt/c/Program Files/Microsoft Office/root/Office16/WINWORD.EXE" /t $1 &
}
autoload -Uz word



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
