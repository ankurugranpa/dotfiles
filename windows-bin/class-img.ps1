[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$teach_dir,

    [Parameter(Mandatory = $true)]
    [string]$serch_dir,

    [Parameter(Mandatory = $true)]
    [string]$out_dir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$teach_dir = (Resolve-Path $teach_dir).Path
$serch_dir = (Resolve-Path $serch_dir).Path
$out_dir   = (Resolve-Path $out_dir -ErrorAction SilentlyContinue)?.Path ?? $out_dir

$okDir = Join-Path $out_dir "ok"
$ngDir = Join-Path $out_dir "ng"

New-Item -ItemType Directory -Force -Path $okDir | Out-Null
New-Item -ItemType Directory -Force -Path $ngDir | Out-Null

# teach_dir 側のファイル名一覧
$teachFiles = Get-ChildItem -Path $teach_dir -File |
              Select-Object -ExpandProperty Name

# serch_dir を再帰的に処理
Get-ChildItem -Path $serch_dir -File -Recurse | ForEach-Object {

    $file = $_
    $base = $file.BaseName   # 例: 3b59299d_0004

    # A 側に base を含むファイルがあるか（prefix 有無両対応）
    $exists = $teachFiles | Where-Object { $_ -like "*$base*" }

    $dst = if ($exists) {
        Join-Path $okDir $file.Name
    } else {
        Join-Path $ngDir $file.Name
    }

    Copy-Item -Path $file.FullName -Destination $dst -Force
}

