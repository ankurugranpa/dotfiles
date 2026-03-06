param(
  [int]$Start = 1,
  [int]$End = 21,
  [string]$Prefix = "scene",
  [string]$BaseDir = (Get-Location).Path
)

if ($Start -gt $End) {
  throw "Start は End 以下にしてください (Start=$Start, End=$End)"
}

$base = Resolve-Path $BaseDir

for ($i = $Start; $i -le $End; $i++) {
  $name = "$Prefix$i"
  $path = Join-Path $base $name
  New-Item -ItemType Directory -Path $path -Force | Out-Null
  Write-Host "created: $path"
}

