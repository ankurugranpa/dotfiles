# 🐔dotfiles for windows🐔
## dependency
Scoop
git

## How to Setup
- Change ExecutionPolicy
```
if((Get-ExecutionPolicy -Scope LocalMachine) -ne "RemoteSigned"){Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force}
```

- Install Scoop
```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
iwr -useb get.scoop.sh | iex
```

- Install git
```
Scoop install git
```

- Install profile
```
git clone -b powershell git@github.com:ankurugranpa/dotfiles.git ~/dotfiles
cd ~/dotfiles/.installer/
./setup.ps1
```
** Restart PowerShell!!** \
When you can use this setting
