param(
    [string]$Out = "out.mp4",
    [int]$Fps = 30,
    [double]$Duration = 2,
    [double]$LastDuration = 5,
    [string]$Ext = "jpg,jpeg,png",
    [string]$ListFile = "list.ffconcat"
)

# 拡張子配列
$exts = @()
foreach ($x in $Ext.Split(",")) {
    $t = $x.Trim().ToLower()
    if ($t) { $exts += $t }
}

# 画像収集（配列に溜める）
$imgs = @()
foreach ($e in $exts) {
    $pattern = Join-Path $PWD "*.$e"
    $found = Get-ChildItem -File -Path $pattern -ErrorAction SilentlyContinue
    if ($found) { $imgs += $found }
}

# ソート
$imgs = $imgs | Sort-Object Name

if (-not $imgs -or $imgs.Count -eq 0) {
    Write-Error "画像が見つかりません（対象拡張子: $Ext / カレント: $PWD）"
    exit 1
}

$last = $imgs[-1].Name

# ffconcat 作成
"ffconcat version 1.0" | Set-Content -Encoding ascii $ListFile

foreach ($i in $imgs) {
    "file '$($i.Name)'" | Add-Content -Encoding ascii $ListFile
    if ($i.Name -eq $last) {
        "duration $LastDuration" | Add-Content -Encoding ascii $ListFile
    } else {
        "duration $Duration" | Add-Content -Encoding ascii $ListFile
    }
}

# 最後の file をもう一回（ffmpeg仕様）
"file '$last'" | Add-Content -Encoding ascii $ListFile

# ffmpeg 実行
ffmpeg -y -safe 0 -i list.ffconcat -fps_mode cfr -r 30 -pix_fmt yuv420p out.mp4

