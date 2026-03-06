$BaseDir = Get-Location

$JpgDir = Join-Path $BaseDir "jpg"
$PngDir = Join-Path $BaseDir "png"

New-Item -ItemType Directory -Path $JpgDir -Force | Out-Null
New-Item -ItemType Directory -Path $PngDir -Force | Out-Null

# jpg / jpeg
Get-ChildItem -Path $BaseDir -File -Filter *.jpg | ForEach-Object {
    Move-Item $_.FullName $JpgDir -ErrorAction SilentlyContinue
}
Get-ChildItem -Path $BaseDir -File -Filter *.jpeg | ForEach-Object {
    Move-Item $_.FullName $JpgDir -ErrorAction SilentlyContinue
}

# png
Get-ChildItem -Path $BaseDir -File -Filter *.png | ForEach-Object {
    Move-Item $_.FullName $PngDir -ErrorAction SilentlyContinue
}

