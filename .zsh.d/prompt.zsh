#プロンプト設定
PROMPT='%n@%h
[%d]#'

#vimライクなコマンドラインにする設定
bindkey -v
#モード表示のスクリプト
PROMPT_INS="%{${fg[blue]}%}[%n@%m] %~%{${reset_color}%}
[INSERT]$ "
PROMPT_NOR="%{${fg[blue]}%}[%n@%m] %~%{${reset_color}%}
[NORMAL]$ "
PROMPT_VIS="%{${fg[blue]}%}[%n@%m] %~%{${reset_color}%}
[VISUAL]$ "

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
