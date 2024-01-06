# スクリプト実行が許可されていなければ許可する
if((Get-ExecutionPolicy -Scope LocalMachine) -ne "RemoteSigned"){Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force}

# Profileの存在判定
if(-not (Test-Path $PROFILE)){
        New-Item $PROFILE -Type File -Force
}
else{
        $backup_dir = "$HOME/prompt_backup"
        if(-not (Test-Path $backup_dir)){
                New-Item $backup_dir -ItemType Directory -Force
        }

        $BuckupFile = "$backup_dir/$(Get-Date -Format 'yyyyMMdd_HHmmss')_backup.txt"
        $ProfileContent = Get-Content $PROFILE  -Raw
        New-Item $BuckupFile
        Add-Content -Path $BuckupFile -Value $ProfileContent
}

# PROFILEの設定
$fileAPath = "./PROFILE.txt"

# ファイルAの内容を読み込む
$fileAContent = Get-Content -Path $fileAPath -Raw

# $PROFILEに内容を追加
Add-Content -Path $PROFILE -Value $fileAContent
