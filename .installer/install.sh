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

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Finish!!!"
