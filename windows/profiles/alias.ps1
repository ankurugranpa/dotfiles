Set-Alias vim nvim # nvimのエイリアス

Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete # 補完の挙動をzshと同じにする

function ls {
    Get-ChildItem | Select-Object -ExpandProperty Name
}
