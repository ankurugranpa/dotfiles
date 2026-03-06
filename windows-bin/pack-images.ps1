[CmdletBinding(DefaultParameterSetName="Scale")]
param(
  [Parameter(Mandatory=$true)]
  [string]$InputDir,

  [Parameter(Mandatory=$true)]
  [string]$OutDir,

  # Scale mode (default): resize small images by ratio (e.g. 0.3333 = 1/3)
  [Parameter(ParameterSetName="Scale", Mandatory=$false)]
  [ValidateRange(0.01, 1.0)]
  [double]$JpegScale = 0.3333,

  # MaxSize mode: resize small images so the longer side <= JpegMaxSize (no upscale)
  [Parameter(ParameterSetName="MaxSize", Mandatory=$true)]
  [ValidateRange(1, 20000)]
  [int]$JpegMaxSize,

  # If specified, do NOT generate small images
  [Parameter(Mandatory=$false)]
  [switch]$NoSmall,

  # Round small image width/height down to multiples (e.g. 8 or 16). 0 disables rounding.
  [Parameter(Mandatory=$false)]
  [ValidateRange(0, 2048)]
  [int]$RoundMultiple = 0,

  [Parameter(Mandatory=$false)]
  [ValidateRange(1, 100)]
  [int]$JpegQuality = 92,

  [Parameter(Mandatory=$false)]
  [ValidateSet("SHA256","SHA1","MD5")]
  [string]$HashAlgo = "SHA256"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Dir([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) {
    New-Item -ItemType Directory -Path $p | Out-Null
  }
}

function Require-Magick {
  if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
    throw "ImageMagick (magick) not found. Install it and ensure it is on PATH."
  }
}

function Get-HashName([string]$filePath, [string]$algo) {
  (Get-FileHash -LiteralPath $filePath -Algorithm $algo).Hash.ToLower()
}

function Get-RelativePathSafe([string]$base, [string]$full) {
  $baseNorm = (Resolve-Path -LiteralPath $base).Path.TrimEnd('\','/')
  $fullNorm = (Resolve-Path -LiteralPath $full).Path
  if ($fullNorm.Length -le $baseNorm.Length) { return (Split-Path -Leaf $fullNorm) }
  return $fullNorm.Substring($baseNorm.Length).TrimStart('\','/')
}

function Get-RoundedGeometryForSmall(
  [string]$srcPath,
  [string]$mode,
  [double]$scale,
  [int]$maxSize,
  [int]$roundMultiple
) {
  if ($roundMultiple -le 1) { return $null }

  $wh = & magick identify -format "%w %h" $srcPath
  if (-not $wh) { return $null }

  $parts = $wh -split '\s+'
  $w = [int]$parts[0]
  $h = [int]$parts[1]
  if ($w -le 0 -or $h -le 0) { return $null }

  if ($mode -eq "Scale") {
    $nw = [int][Math]::Round($w * $scale)
    $nh = [int][Math]::Round($h * $scale)
  } elseif ($mode -eq "MaxSize") {
    $long = [Math]::Max($w, $h)
    if ($long -le $maxSize) {
      $nw = $w; $nh = $h
    } else {
      $s = $maxSize / $long
      $nw = [int][Math]::Round($w * $s)
      $nh = [int][Math]::Round($h * $s)
    }
  } else {
    return $null
  }

  $nw = [Math]::Max(1, $nw)
  $nh = [Math]::Max(1, $nh)

  $nw2 = [int]([Math]::Floor($nw / $roundMultiple) * $roundMultiple)
  $nh2 = [int]([Math]::Floor($nh / $roundMultiple) * $roundMultiple)
  if ($nw2 -lt $roundMultiple) { $nw2 = $roundMultiple }
  if ($nh2 -lt $roundMultiple) { $nh2 = $roundMultiple }

  return ("{0}x{1}!" -f $nw2, $nh2)
}

# --- main ---
Require-Magick

$InputDir = (Resolve-Path -LiteralPath $InputDir).Path
Ensure-Dir $OutDir

$jpgCleanDir = Join-Path $OutDir "jpg_clean"
$jpgSmallDir = Join-Path $OutDir "jpg_small"
$pngDir      = Join-Path $OutDir "png"

Ensure-Dir $jpgCleanDir
Ensure-Dir $jpgSmallDir
Ensure-Dir $pngDir

$jpgs = Get-ChildItem -LiteralPath $InputDir -Recurse -File |
  Where-Object { $_.Extension -match '^\.(jpg|jpeg)$' -or $_.Extension -match '^\.(JPG|JPEG)$' }

$pngs = Get-ChildItem -LiteralPath $InputDir -Recurse -File |
  Where-Object { $_.Extension -ieq '.png' }

foreach ($f in $jpgs) {
  $hash = Get-HashName -filePath $f.FullName -algo $HashAlgo
  $dstClean = Join-Path $jpgCleanDir ($hash + ".jpg")
  $dstSmall = Join-Path $jpgSmallDir ($hash + ".jpg")

  if (-not (Test-Path -LiteralPath $dstClean)) {
    & magick $f.FullName -auto-orient -strip -quality $JpegQuality -interlace Plane $dstClean
  }

  if (-not $NoSmall -and -not (Test-Path -LiteralPath $dstSmall)) {
    $geometry = $null
    if ($RoundMultiple -gt 1) {
      if ($PSCmdlet.ParameterSetName -eq "Scale") {
        $geometry = Get-RoundedGeometryForSmall -srcPath $f.FullName -mode "Scale" -scale $JpegScale -maxSize 0 -roundMultiple $RoundMultiple
      } else {
        $geometry = Get-RoundedGeometryForSmall -srcPath $f.FullName -mode "MaxSize" -scale 0 -maxSize $JpegMaxSize -roundMultiple $RoundMultiple
      }
    }

    if ($geometry) {
      & magick $f.FullName -auto-orient -strip -resize $geometry -quality $JpegQuality -interlace Plane $dstSmall
    } else {
      if ($PSCmdlet.ParameterSetName -eq "Scale") {
        $percent = [int]([Math]::Round($JpegScale * 100))
        & magick $f.FullName -auto-orient -strip -resize "$percent%" -quality $JpegQuality -interlace Plane $dstSmall
      } else {
        & magick $f.FullName -auto-orient -strip -resize "$($JpegMaxSize)x$($JpegMaxSize)>" -quality $JpegQuality -interlace Plane $dstSmall
      }
    }
  }
}

foreach ($f in $pngs) {
  $rel = Get-RelativePathSafe -base $InputDir -full $f.FullName
  $dst = Join-Path $pngDir $rel
  Ensure-Dir (Split-Path -Parent $dst)
  if (-not (Test-Path -LiteralPath $dst)) {
    Copy-Item -LiteralPath $f.FullName -Destination $dst
  }
}

$zipJpgClean = Join-Path $OutDir "jpg_clean.zip"
$zipPng      = Join-Path $OutDir "png.zip"

if (Test-Path -LiteralPath $zipJpgClean) { Remove-Item -LiteralPath $zipJpgClean -Force }
if (Test-Path -LiteralPath $zipPng)      { Remove-Item -LiteralPath $zipPng -Force }

Compress-Archive -Path (Join-Path $jpgCleanDir "*") -DestinationPath $zipJpgClean
Compress-Archive -Path (Join-Path $pngDir "*")      -DestinationPath $zipPng

Write-Host "[DONE]"
Write-Host ("JPG clean zip: {0}" -f $zipJpgClean)
Write-Host ("PNG zip      : {0}" -f $zipPng)
Write-Host ("JPG small dir: {0} (not zipped)" -f $jpgSmallDir)

