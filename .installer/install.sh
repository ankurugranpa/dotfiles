#!/bin/bash
#引数の設定
NVIM_INSTALL_PATH=$HOME/dotfiles/mybin-local/bin

#backupファイルの作成
if [ -e $HOME/.config_backup ]; then
	echo "[exist] backupfile"
else
	echo "[make] backupfaile"
	mkdir $HOME/.config_backup
fi
#バックアップファイル内に作業ファイルを作成する
#何らかのことがあったときのためファイルは日時で管理する
backup=$HOME/.config_backup/$(date +%Y%m%d%H%W)
mkdir $backup
#install_file.txtファイル内に記述されたファイルの存在確認
#ファイルが存在した場合は場はbackupに格納する
#シンボリックリンクを作成する
while read line
do
	FILE=$HOME/$line
        if [ -e $FILE ]; then
		echo "[exist]$line"
		mv $FILE $backup/$line
	        ln -s $HOME/dotfiles/$line $FILE		
        else
	        echo "[no exist]$line"	
	        ln -s $HOME/dotfiles/$line $FILE
	fi
done < $HOME/dotfiles/.installer/install_file.txt
touch $HOME/dotfiles/.zsh.d/env.zsh

#ubuntuの場合ログインシェルを変更する
#if [ $SHELL_TYPE==2 ]; then
#	sudo apt-get install zsh
#	chsh -s $(which zsh)
#fi

#denoのインストール
if [ $1 = -deno]; then
	echo "[install] deno"
        curl -fsSL https://deno.land/install.sh | sh
        deno run https://deno.land/std/examples/welcome.ts
	
fi

# nvimのインストール
# wget "https://github.com/neovim/neovim/archive/refs/tags/stable.tar.gz" -O "nvim_install_file.tar.gz" -p $NVIM_INSTALL_PATH
# tar -zxvf "$NVIM_INSTALL_PATH/nvim_install_file.tar.gz"
# rm -r "$NVIM_INSTALL_PATH/nvim_install_file.tar.gz"
# rm -r "$NVIM_INSTALL_PATH/nvim_install_file/build/"
# make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
# sudo make install
# export PATH="$HOME/neovim/bin:$PATH"


# clear the CMake cache
# make install CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
# make install


# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#zplugのインストール
echo "[install] zplug"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
source $HOME/.zshrc
zplug install

#vim-plugのインストール
echo "[install] vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Finish!!!"
