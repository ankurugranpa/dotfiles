# 🐔dotfiles for zsh🐔
## dependency
- zsh
- [NeoVim]("https://github.com/neovim/neovim")
- [LazyGit]("https://github.com/jesseduffield/lazygit")
- [NerdFonts]("https://github.com/ryanoasis/nerd-fonts")
- [tiktoken-core.so]("https://github.com/gptlang/lua-tiktoken")

## Install
```
git clone https://github.com/ankurugranpa/dotfiles.git
cd dotfiles/.installer
bash install.sh
cd ~
source .zshrc
```

## zsh
setting files path:`.zsh.d/`
### plugin  manager
[zplug](https://github.com/zplug/zplug)


## NeoVim
setting files path:`.config/nvim`
### plugin manager
[Lazy.nvim](https://github.com/folke/lazy.nvim)
- usage:
```
:Lazy
```

### Lsp Manager 
[mason.nvim](https://github.com/williamboman/mason.nvim)
- usage:
install lsp
```
:MasonInstall <lsp server name>
```

## Font
using NerdFonts
ex)
[白原](https://github.com/yuru7/HackGen)
