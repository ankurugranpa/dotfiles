# 非対話シェルでは何も読み込まない
[[ $- != *i* ]] && return

ZSH_DIR="${HOME}/.zsh.d"

# .zshがディレクトリで、読み取り、実行、が可能なとき
if [ -d $ZSH_DIR ] && [ -r $ZSH_DIR ] && [ -x $ZSH_DIR ]; then
    # zshディレクトリより下にある、.zshファイルの分、繰り返す
    for file in ${ZSH_DIR}/**/*.zsh; do
        # 読み取り可能ならば実行する
        [ -r $file ] && source $file
    done
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

__conda_setup="$('/home2/tf/tfx73770/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home2/tf/tfx73770/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home2/tf/tfx73770/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home2/tf/tfx73770/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

export NODEBREW_ROOT=$HOME/.nodebrew
echo 'export NODEBREW_ROOT=$HOME/.nodebrew' >> ~/.zshrc

# nodebrewのパスを通す
export NODEBREW_ROOT=$HOME/.nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
export NODEBREW_ROOT=$HOME/.nodebrew

# XDG_RUNTIME_DIRを設定
export NODEBREW_ROOT=$HOME/.nodebrew
export XDG_RUNTIME_DIR=/tmp/runtime-$USER
