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



function tmux_sync_pain {
  session_name="$1"
  pane_count="$2"

  # 新しいセッションを作成
  tmux new-session -d -s $session_name

  # 指定された数のペインを作成
  for i in $(seq 1 $pane_count); do
      tmux split-window -t $session_name -h   # 横に分割
      tmux select-layout -t $session_name tiled # ペインをタイル状に配置
  done

  # ペインを同期させるオプションを有効にする
  tmux set-window-option -t $session_name synchronize-panes on

  # 最後にセッションをアタッチ
  tmux attach-session -t $session_name
}

autoload -Uz tmux_sync_pain

function serena_mcp {
  claude mcp add serena --scope project -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project $(pwd)
}

autoload -Uz serena_mcp

function copilotfile-gen {
  mkdir -p "$(pwd)/.copilot/prompts"
  ln -sfn "$HOME/.copilot/prompts" "$(pwd)/.copilot/prompts"
}

autoload -Uz copilotfile-gen
