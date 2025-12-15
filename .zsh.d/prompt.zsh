# Copilot / Vscodeの安定化
# VSCode Terminal 判定
IS_VSCODE=0
[[ "$TERM_PROGRAM" == "vscode" ]] && IS_VSCODE=1

# Copilot が実行結果を読む用の安全モード
if (( IS_VSCODE )); then
  # vim モード無効（ここが一番効く）
  bindkey -e

  # シンプル・1行・副作用なしプロンプト
  PROMPT='%n:%~$ '

  unset RPS1
else



  #カラーコードの追加
  autoload -Uz colors
  colors
  #プロンプト設定
  #PROMPT="$%n@%h
  #[%d]#"
  #vimライクなコマンドラインにする設定
  bindkey -v
  #PROMPTの表示設定(一般ユーザーの時)
  PROMPT_INS='${fg[green]}%n${reset_color}`python_venv``conda_env``git-prompt``singularity_env`|%~
--INSERT--$' 
  PROMPT_NOR='${fg[green]}%n${reset_color}`python_venv``conda_env``git-prompt``singularity_env`|%~
--NORMAL--$ '
  PROMPT_VIS='${fg[green]}%n${reset_color}`python_venv``conda_env``git-prompt``singularity_env`|%~
--VISUAL--$' 

  if [ ${UID} -eq 0 ]; then
    #PROMPTの表示設定(rootユーザーの時)
    PROMPT_INS='(root)${fg[green]}%n${reset_color}`python_venv``conda_env``git-prompt``singularity_env`|%~
--INSERT--$'
    PROMPT_NOR='(root)${fg[green]}%n${reset_color}`python_venv``conda_env``git-prompt``singularity_env`|%~
--NORMAL--$'
    PROMPT_VIS='(root)${fg[green]}%n${reset_color}`python_venv``conda_env``git-prompt``singularity_env`|%~
--VISUAL--$'
  fi
  #venvのステータス表示
  function python_venv {
    if [ -n "$VIRTUAL_ENV" ]; then
      PYTHON_VENV_STATUS="(`basename "$VIRTUAL_ENV"`)"
      echo $PYTHON_VENV_STATUS
    fi
  }
  function conda_env {
    if [ -n "$CONDA_PROMPT_MODIFIER" ]; then
      echo $CONDA_PROMPT_MODIFIER
    fi
  }

  function singularity_env {
    if [ -n "$SINGULARITY_NAME" ]; then
      
      echo "(`basename "$SINGULARITY_NAME" ".sif"`)"
    fi
  }

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
  zle -N what_venv

  function git-prompt {
    local branchname branch st remote pushed upstream
    branchname=`git symbolic-ref --short HEAD 2> /dev/null`
    if [ -z $branchname ]; then
      return
    fi
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
      branch="%{${fg[green]}%}($branchname)%{$reset_color%}"
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
      branch="%{${fg[yellow]}%}($branchname)%{$reset_color%}"
    else
      branch="%{${fg[red]}%}($branchname)%{$reset_color%}"
    fi

    remote=`git config branch.${branchname}.remote 2> /dev/null`

    if [ -z $remote ]; then
      pushed=''
    else
      upstream="${remote}/${branchname}"
      if [[ -z `git log ${upstream}..${branchname}` ]]; then
        pushed="%{${fg[green]}%}[up]%{$reset_color%}"
      else
        pushed="%{${fg[red]}%}[up]%{$reset_color%}"
      fi
    fi

    echo "$branch$pushed"
  }

  setopt prompt_subst
fi
