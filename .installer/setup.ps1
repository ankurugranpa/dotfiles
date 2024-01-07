# スクリプト実行が許可されていなければ許可する
if((Get-ExecutionPolicy -Scope LocalMachine) -ne "RemoteSigned"){Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force}

# Profileの存在判定
if((Test-Path $PROFILE)){
        $backup_dir = "$HOME/prompt_backup"
        if(-not (Test-Path $backup_dir)){
                New-Item $backup_dir -ItemType Directory -Force
        }

        $BuckupFile = "$backup_dir/$(Get-Date -Format 'yyyyMMdd_HHmmss')_backup.txt"
        $ProfileContent = Get-Content $PROFILE  -Raw
        New-Item $BuckupFile
	Add-Content -Path $BuckupFile -Value $ProfileContent
	Remove-Item $PROFILE
}
New-Item $PROFILE -Type File -Force


# PROFILEの設定
$profile_txt = "../windows/PROFILE.txt"

$fileAContent = Get-Content -Path $profile_txt -Raw

# $PROFILEに内容を追加
Add-Content -Path $PROFILE -Value $fileAContent

# Install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh -s winget

## Install from scoop
scoop install busybox
scoop install fzf
