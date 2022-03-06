#!/bin/bash
#引数の設定
if [ $# -ne 1 ]; then
	echo "error:you need to set -arg1"
	exit 1
fi

if [ $1 = -arch ]; then
	SHELL_TYPE=1
elif [ $1 = -ubuntu ]; then
	SHELL_TYPE=2
fi


#backupファイルの作成
if [ -e ~/backup ]; then
	echo "exist backupfile"
else
	echo "making backupfaile"
	mkdir ~/backup
fi
#バックアップファイル内に作業ファイルを作成する
#何らかのことがあったときのためファイルは日時で管理する
backup=~/backup/$(date +%Y%m%d%H%W)
mkdir $backup
#install_file.txtファイル内に記述されたファイルの存在確認
#ファイルが存在した場合は場はbackupに格納する
#シンボリックリンクを作成する
while read line
do
	FILE=~/$line
        if [ -e $FILE ]; then
		echo "$lineは存在しました"
		mv $FILE $backup/$line
	        ln -s ~/dotfiles/$line $FILE		
        else
	        echo "$lineは存在しませんでした"	
	        ln -s ~/dotfiles/$line $FILE
	fi
done < ~/dotfiles/install_file.txt

#ubuntuの場合ログインシェルを変更する
if [ $SHELL_TYPE==2 ]; then
	sudo apt-get install zsh
	chsh -s $(which zsh)
fi
#denoのインストール
curl -fsSL https://deno.land/install.sh | sh

#zplugのインストール
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

zplug install

source ~/.zshrc
#vim-plugのインストール
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "インストールに成功しました　vim-plugでプラグインを最後にインストールしてください"
