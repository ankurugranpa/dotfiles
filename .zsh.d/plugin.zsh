source ~/.zplug/init.zsh

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "b4b4r07/enhancd", use:"init.sh"

if ! zplug check --verbose; then
  zplug install
fi

zplug load --verbose
