function venv {
	source venv/bin/activate
}
autoload -Uz venv


function word {
	"/mnt/c/Program Files/Microsoft Office/root/Office16/WINWORD.EXE" /t $1 &
}
autoload -Uz word

function pdf {
	pdf_path=`wslpath -w $1`
	/mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe $pdf_path
}
autoload -Uz pdf

function open {
	desktop_num=${2:=1}
	"/mnt/c/Program Files (x86)/VDesk/VDesk.exe" on:$desktop_num run:cmd.exe /C start /max $1 


}
autoload -Uz open

#function aiueo {
#	desktop_num=${2:=1}
#	if [[ $1 == *".pdf" ]]
#	then
#		desktop_num=3
#	elif [[ $1 == *".docx" ]]
#	then
#		desktop_num=4
#	fi
#	"/mnt/c/Program Files (x86)/VDesk/VDesk.exe" on:$desktop_num run:cmd.exe /C start /max $1 
#}

#autoload -Uz aiueo
