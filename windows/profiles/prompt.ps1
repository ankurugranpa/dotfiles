Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit # ctrl-Dの有効化

# oh-my-poshの設定
# oh-my-posh init pwsh --config "$HOME/dotfiles/windows/themes/tokyo.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$HOME/dotfiles/windows/themes/blueish.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$HOME/dotfiles/windows/themes/froczh.omp.json" | Invoke-Expression

# fzf
function ghq-fzf {
  $repo = $(ghq list | fzf)
  Set-Location ( Join-Path $(ghq root) $repo)
}

function ghq-fzf {
  $repo = $(ghq list | fzf)
  Set-Location ( Join-Path $(ghq root) $repo)
}

Set-PSReadLineKeyHandler -Chord Ctrl+g -ScriptBlock { 
  ghq-fzf
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine() 
}
