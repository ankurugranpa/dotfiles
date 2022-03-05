#!/bin/bash
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


#zplugのインストール
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
