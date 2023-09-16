autoload -U compinit
compinit
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

# historyコマンドは履歴に登録しない
setopt hist_no_store

# PATH
# デフォルトのエディタ
export EDITOR=vim
# NeoVim用のpath
export XDG_CONFIG_HOME=~/.config/
# 自作コマンドのディレクトリ
export PATH=$PATH:~/dotfiles/.mybin
# ローカルのコマンドディレクトリ
export PATH=$PATH:~/dotfiles/mybin-local
# Deno用
export DENO_INSTALL="/$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
# alias
alias vim='nvim'
export PATH=$PATH:~/dotfiles/mybin-local/bin


