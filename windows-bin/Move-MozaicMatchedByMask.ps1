param(
    [Parameter(Mandatory = $true)]
    [string]$root,

    [switch]$DryRun
)

# 対象拡張子
$ImageExts = @(".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tif", ".tiff")

$rootPath = (Resolve-Path $root).Path

$segRemove   = Join-Path $rootPath "seg\remove"
$mozaicDir   = Join-Path $rootPath "mozaic"
$mozaicRemove = Join-Path $mozaicDir "remove"

# existence check
if (-not (Test-Path $segRemove)) {
    throw "seg/remove が見つかりません: $segRemove"
}
if (-not (Test-Path $mozaicDir)) {
    throw "mozaic ディレクトリが見つかりません: $mozaicDir"
}

if (-not $DryRun) {
    if (-not (Test-Path $mozaicRemove)) {
        New-Item -ItemType Directory -Path $mozaicRemove | Out-Null
    }
}

# seg/remove 側（mask側）のファイル名セット
$maskNames = New-Object 'System.Collections.Generic.HashSet[string]'
Get-ChildItem $segRemove -File |
    Where-Object { $ImageExts -contains $_.Extension.ToLower() } |
    ForEach-Object { [void]$maskNames.Add($_.Name) }

$moved = 0
$skipped = 0

# mozaic 直下の画像だけ対象（必要なら -Recurse に変更できる）
Get-ChildItem $mozaicDir -File |
    Where-Object {
        $ImageExts -contains $_.Extension.ToLower() -and
        $_.DirectoryName -ne $mozaicRemove
    } |
    ForEach-Object {
        if ($maskNames.Contains($_.Name)) {
            $dst = Join-Path $mozaicRemove $_.Name

            # 重複回避（remove に同名が既にあれば __dup1 など）
            if (Test-Path $dst) {
                $i = 1
                while ($true) {
                    $newName = "{0}__dup{1}{2}" -f $_.BaseName, $i, $_.Extension
                    $dst2 = Join-Path $mozaicRemove $newName
                    if (-not (Test-Path $dst2)) { $dst = $dst2; break }
                    $i++
                }
            }

            if ($DryRun) {
                Write-Host "[DRY] MOVE: $($_.FullName) -> $dst"
            } else {
                Move-Item -LiteralPath $_.FullName -Destination $dst
                Write-Host "MOVE: $($_.Name) -> mozaic/remove/"
            }
            $moved++
        } else {
            $skipped++
        }
    }

Write-Host ""
Write-Host "Root:        $rootPath"
Write-Host "Mask dir:    $segRemove"
Write-Host "Mozaic dir:  $mozaicDir"
Write-Host "Remove dir:  $mozaicRemove"
Write-Host "Done. moved=$moved, not_matched=$skipped"

