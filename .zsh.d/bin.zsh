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
	if [ $1 = "webclass" ];then
		action="https://ecsylms1.kj.yamagata-u.ac.jp/webclass/login.php?rnd=b0f03&language=JAPANESE"
	elif [ $1 = "chrome" ];then
		action="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
		"/mnt/c/Program Files (x86)/VDesk/VDesk.exe" on:$desktop_num run:cmd.exe /C "C:\Program Files\Google\Chrome\Application\chrome.exe"
		return 0
	else
		action=$1
	fi

	desktop_num=${2:=1}

	"/mnt/c/Program Files (x86)/VDesk/VDesk.exe" on:$desktop_num run:cmd.exe /C start /max $action 
}
autoload -Uz open_beta
