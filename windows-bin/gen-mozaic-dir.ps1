[CmdletBinding()]
param(
  # scene1, scene2,... が入っている親ディレクトリ
  [Parameter(Mandatory = $true)]
  [string]$TargetDir,

  # 出力ディレクトリ（集約先）
  [Parameter(Mandatory = $true)]
  [string]$OutDir,

  # ディレクトリ名のプレフィックス
  [string]$ScenePrefix = "scene",

  # scene*/ 配下の画像が入っているサブディレクトリ名
  [string]$SubDirName = "mozaic",

  # 何桁ゼロ埋めするか (例: 3 -> 001)
  [int]$PadWidth = 3,

  # 対象拡張子（複数OK）
  [string[]]$Exts = @(".jpg"),

  # コピーにしたい場合は -Copy を付ける
  [switch]$Copy
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$TargetDir = (Resolve-Path $TargetDir).Path

# OutDir が相対ならカレント基準で作る（既存ならそのまま）
# OutDir の解決
if ([System.IO.Path]::IsPathRooted($OutDir)) {
    # 絶対パス
    $OutDir = $OutDir
}
else {
    # 相対パス
    $OutDir = Join-Path (Get-Location) $OutDir
}

# 正規化
$OutDir = [System.IO.Path]::GetFullPath($OutDir)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

# sceneNNN 形式のディレクトリを収集して、NNN を数値としてソート
$pattern = "^{0}(\d+)$" -f [Regex]::Escape($ScenePrefix)

# 拡張子の正規化（小文字・先頭ドット保証）
$extSet = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($e in $Exts) {
  $x = $e.Trim().ToLower()
  if (-not $x.StartsWith(".")) { $x = "." + $x }
  [void]$extSet.Add($x)
}

$dirs = Get-ChildItem -Path $TargetDir -Directory |
  Where-Object { $_.Name -match $pattern } |
  Sort-Object @{ Expression = { [int]([regex]::Match($_.Name, $pattern).Groups[1].Value) }; Ascending = $true }, Name

foreach ($dir in $dirs) {
  $m = [regex]::Match($dir.Name, $pattern)
  $num = [int]$m.Groups[1].Value
  $prefix = $num.ToString(("D{0}" -f $PadWidth))   # 1 -> 001 (PadWidth=3)

  $src = Join-Path $dir.FullName $SubDirName
  if (-not (Test-Path $src)) {
    Write-Verbose "skip: subdir not found -> $src"
    continue
  }

  Get-ChildItem -Path $src -File |
    Where-Object { $extSet.Contains($_.Extension.ToLower()) } |
    Sort-Object Name |
    ForEach-Object {
      $base = $_.BaseName
      $ext  = $_.Extension.ToLower()
      $dstName = "${prefix}_${base}${ext}"
      $dstPath = Join-Path $OutDir $dstName

      # 同名衝突回避
      $i = 1
      while (Test-Path $dstPath) {
        $dstName = "{0}_{1}_{2:D3}{3}" -f $prefix, $base, $i, $ext
        $dstPath = Join-Path $OutDir $dstName
        $i++
      }

      if ($Copy) {
        Copy-Item -LiteralPath $_.FullName -Destination $dstPath
      } else {
        Move-Item -LiteralPath $_.FullName -Destination $dstPath
      }
    }
}

"done -> $OutDir"
