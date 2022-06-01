#カラーコードの追加
autoload -Uz colors
colors
#プロンプト設定
#PROMPT="$%n@%h
#[%d]#"
#vimライクなコマンドラインにする設定
bindkey -v
#PROMPTの表示設定
PROMPT_INS="${fg[green]}%n${reset_color}|%~
--INSERT--$ "
PROMPT_NOR="${fg[green]}%n${reset_color}|%~
--NORMAL--$ "
PROMPT_VIS="${fg[green]}%n${reset_color}|%~
--VISUAL--$ "

PROMPT=$PROMPT_INS

function zle-line-pre-redraw {
  if [[ $REGION_ACTIVE -ne 0 ]]; then
    NEW_PROMPT=$PROMPT_VIS
  elif [[ $KEYMAP = vicmd ]]; then
    NEW_PROMPT=$PROMPT_NOR
  elif [[ $KEYMAP = main ]]; then
    NEW_PROMPT=$PROMPT_INS
  fi

  if [[ $PROMPT = $NEW_PROMPT ]]; then
    return
  fi

  PROMPT=$NEW_PROMPT

  zle reset-prompt
}

function zle-keymap-select zle-line-init {
  case $KEYMAP in
    vicmd)
    PROMPT=$PROMPT_NOR
    ;;
    main|viins)
    PROMPT=$PROMPT_INS
    ;;
  esac
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-pre-redraw
#venvの設定
function what-venv {

  if [ -n "$VIRTUAL_ENV" ]; then
  	echo "(venv:${VIRTUAL_ENV##*/})"
  fi
  
}
# ここら下はbranch名を表示させるメソッドの設定-----------------------------

function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てコミットされてクリーンな状態
    branch_status=""
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status=" !"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status=" *"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status=" +"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red} !!"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status=""
  fi
  # ブランチ名を色付きで表示する
  echo "($branch_name${branch_status})"
}

# プロンプトが表示されるたび、毎回プロンプトの文字列を評価し、置換する
setopt prompt_subst
