[CmdletBinding()]
param(
  # scene1, scene2,... が入っている親ディレクトリ
  [Parameter(Mandatory = $true)]
  [string]$TargetDir,

  # 出力ディレクトリ名
  [Parameter(Mandatory = $true)]
  [string]$OutDir,

  # ディレクトリ名のプレフィックス
  [string]$ScenePrefix = "scene",

  # 何桁ゼロ埋めするか (例: 3 -> 001)
  [int]$PadWidth = 3
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$TargetDir = (Resolve-Path $TargetDir).Path

# OutDir が相対ならカレント基準で作る（既存ならそのまま）
try {
  $OutDir = (Resolve-Path (Join-Path (Get-Location) $OutDir) -ErrorAction Stop).Path
} catch {
  $OutDir = (Join-Path (Get-Location) $OutDir)
}

$ZipPath = "$OutDir.zip"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

# jpg のみ
$ext = ".jpg"

# sceneNNN 形式のディレクトリを収集して、NNN を数値としてソート
$pattern = "^{0}(\d+)$" -f [Regex]::Escape($ScenePrefix)

$dirs = Get-ChildItem -Path $TargetDir -Directory |
  Where-Object { $_.Name -match $pattern } |
  Sort-Object @{ Expression = { [int]([regex]::Match($_.Name, $pattern).Groups[1].Value) }; Ascending = $true }, Name

foreach ($dir in $dirs) {
  $m = [regex]::Match($dir.Name, $pattern)
  $num = [int]$m.Groups[1].Value
  $prefix = $num.ToString(("D{0}" -f $PadWidth))   # 1 -> 001 (PadWidth=3)

  $src = $dir.FullName

  Get-ChildItem -Path $src -File |
    Where-Object { $_.Extension.ToLower() -eq $ext } |
    Sort-Object Name |
    ForEach-Object {
      $base = $_.BaseName
      $dstName = "${prefix}_${base}${ext}"
      $dstPath = Join-Path $OutDir $dstName

      # 同名衝突回避
      $i = 1
      while (Test-Path $dstPath) {
        $dstName = "{0}_{1}_{2:D3}{3}" -f $prefix, $base, $i, $ext
        $dstPath = Join-Path $OutDir $dstName
        $i++
      }

      Move-Item -LiteralPath $_.FullName -Destination $dstPath
    }
}

# 既存 zip があれば削除
if (Test-Path $ZipPath) {
  Remove-Item $ZipPath -Force
}

# zip化
Compress-Archive -Path $OutDir -DestinationPath $ZipPath

"done -> $OutDir , zip -> $ZipPath"

