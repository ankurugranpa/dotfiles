param (
    [Parameter(Mandatory=$true)]
    [string]$InputDir
)

# パスの解決
$inputPath = (Resolve-Path $InputDir).Path
$outputDir = Join-Path $inputPath "out"

if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# ファイル取得
$files = Get-ChildItem -Path $inputPath | Where-Object { $_.Extension -match '\.(jpg|jpeg|png|bmp)$' }

if ($files.Count -eq 0) {
    Write-Warning "画像ファイルが見つかりませんでした: $inputPath"
    return
}

Write-Host "処理開始: $inputPath ($($files.Count)個のファイル)" -ForegroundColor Cyan

foreach ($file in $files) {
    $outputPath = Join-Path $outputDir $file.Name
    
    # 元の画像サイズ（幅x高さ）を取得
    $size = magick identify -format "%wx%h" "$($file.FullName)"
    
    # 処理ロジック:
    # 1. 105%に大きく拡大（予備の画素を作る）
    # 2. -gravity center -extent で中央を切り抜くが、
    #    +0-52 (上に52pxずらして切り抜く＝中身は下に52pxずれる) と
    #    +0+52 (下に52pxずらして切り抜く＝中身は上に52pxずれる) を指定します。
    # この方法なら、回り込みは絶対に発生しません。
    # 最後に、元のサイズに合わせて解像度を復元します。
    & magick "$($file.FullName)" `
        -resize 105%^ `
        -gravity center -extent $size+0-52 `
        -resize 105%^ `
        -gravity center -extent $size+0+52 `
        -resize "$size!" `
        "$outputPath"

    if (Test-Path $outputPath) {
        Write-Host "完了: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`nすべての処理が完了しました。回り込みがないか確認してください。" -ForegroundColor Cyan
