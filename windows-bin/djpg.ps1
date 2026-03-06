[CmdletBinding(DefaultParameterSetName="Scale")]
param(
  [Parameter(Mandatory=$true)]
  [string]$InputDir,

  [Parameter(Mandatory=$true)]
  [string]$OutDir,

  # Scale mode (default): resize by ratio (e.g. 0.3333 = 1/3)
  [Parameter(ParameterSetName="Scale")]
  [ValidateRange(0.01, 1.0)]
  [double]$Scale = 0.3333,

  # MaxSize mode: longer side <= MaxSize (no upscale)
  [Parameter(ParameterSetName="MaxSize", Mandatory=$true)]
  [ValidateRange(1, 20000)]
  [int]$MaxSize,

  # Round width/height down to multiples (0 disables)
  [Parameter()]
  [ValidateRange(0, 2048)]
  [int]$RoundMultiple = 0,

  [Parameter()]
  [ValidateRange(1, 100)]
  [int]$Quality = 92
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Require-Magick {
  if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
    throw "ImageMagick (magick) not found in PATH."
  }
}

function Ensure-Dir([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) {
    New-Item -ItemType Directory -Path $p | Out-Null
  }
}

function Get-RoundedGeometry(
  [string]$src,
  [string]$mode,
  [double]$scale,
  [int]$maxSize,
  [int]$round
) {
  if ($round -le 1) { return $null }

  $wh = & magick identify -format "%w %h" $src
  if (-not $wh) { return $null }

  $w, $h = $wh -split ' ' | ForEach-Object { [int]$_ }

  if ($mode -eq "Scale") {
    $nw = [Math]::Round($w * $scale)
    $nh = [Math]::Round($h * $scale)
  } else {
    $long = [Math]::Max($w, $h)
    if ($long -le $maxSize) { return $null }
    $s = $maxSize / $long
    $nw = [Math]::Round($w * $s)
    $nh = [Math]::Round($h * $s)
  }

  $nw = [Math]::Max($round, [Math]::Floor($nw / $round) * $round)
  $nh = [Math]::Max($round, [Math]::Floor($nh / $round) * $round)

  return "$($nw)x$($nh)!"
}

# --- main ---
Require-Magick

$InputDir = (Resolve-Path $InputDir).Path
Ensure-Dir $OutDir

$jpgs = Get-ChildItem $InputDir -Recurse -File |
  Where-Object { $_.Extension -match '^\.(jpg|jpeg)$' }

foreach ($f in $jpgs) {
  $dst = Join-Path $OutDir $f.Name
  if (Test-Path $dst) { continue }

  $geometry = $null
  if ($RoundMultiple -gt 1) {
    if ($PSCmdlet.ParameterSetName -eq "Scale") {
      $geometry = Get-RoundedGeometry $f.FullName "Scale" $Scale 0 $RoundMultiple
    } else {
      $geometry = Get-RoundedGeometry $f.FullName "MaxSize" 0 $MaxSize $RoundMultiple
    }
  }

  if ($geometry) {
    & magick $f.FullName -auto-orient -strip -resize $geometry -quality $Quality $dst
  } else {
    if ($PSCmdlet.ParameterSetName -eq "Scale") {
      $pct = [int]($Scale * 100)
      & magick $f.FullName -auto-orient -strip -resize "$pct%" -quality $Quality $dst
    } else {
      & magick $f.FullName -auto-orient -strip -resize "${MaxSize}x${MaxSize}>" -quality $Quality $dst
    }
  }
}

Write-Host "[DONE] djpg finished."
Write-Host "Input : $InputDir"
Write-Host "Output: $OutDir"

