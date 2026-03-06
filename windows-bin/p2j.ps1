# 実行ディレクトリ
$BaseDir = Get-Location
$OutDir = Join-Path $BaseDir "jpg"

# 出力ディレクトリ作成
if (!(Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir | Out-Null
}

Add-Type -AssemblyName System.Drawing

# JPEG コーデック取得
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq "image/jpeg" }

# Quality = 100（JPEGで可能な最大品質）
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality,
    100
)

Get-ChildItem $BaseDir -Filter *.png | ForEach-Object {
    $inputPath = $_.FullName
    $outputPath = Join-Path $OutDir ($_.BaseName + ".jpg")

    $img = [System.Drawing.Image]::FromFile($inputPath)
    $img.Save($outputPath, $jpegCodec, $encoderParams)
    $img.Dispose()

    Write-Host "Converted: $($_.Name) -> jpg\$($_.BaseName).jpg"
}

