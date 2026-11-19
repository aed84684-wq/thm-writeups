<#
.SYNOPSIS
    Mask a rectangle (or several) on a screenshot with a black box and optional label text.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools/mask.ps1 -Path docs/img/02-nmap.png -X 120 -Y 340 -W 260 -H 30 -Text "10.x.x.x"

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools/mask.ps1 -Path a.png -Rect "100,200,300,40;100,260,300,40"

.NOTES
    Output defaults to <name>-masked.png next to the input file.
#>
param(
    [Parameter(Mandatory = $true)][string]$Path,
    [int]$X = 0,
    [int]$Y = 0,
    [int]$W = 0,
    [int]$H = 0,
    [string]$Text = "",
    [string]$Rect = "",
    [string]$Out = ""
)

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $Path)) { throw "image not found: $Path" }
if (-not $Out) {
    $dir = Split-Path $Path -Parent
    $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $Out = Join-Path $dir ($name + "-masked.png")
}

$rects = @()
if ($Rect) {
    foreach ($item in $Rect.Split(';')) {
        if (-not $item.Trim()) { continue }
        $parts = $item.Split(',')
        $rects += , @([int]$parts[0], [int]$parts[1], [int]$parts[2], [int]$parts[3])
    }
}
elseif ($W -gt 0 -and $H -gt 0) {
    $rects += , @($X, $Y, $W, $H)
}
else {
    throw "specify -X -Y -W -H, or -Rect 'x,y,w,h;x,y,w,h'"
}

$resolved = (Resolve-Path $Path).Path
$bmp = [System.Drawing.Bitmap]::FromFile($resolved)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)

foreach ($r in $rects) {
    $g.FillRectangle([System.Drawing.Brushes]::Black, $r[0], $r[1], $r[2], $r[3])
    if ($Text) {
        $g.DrawString($Text, $font, [System.Drawing.Brushes]::White, [float]($r[0] + 6), [float]($r[1] + 3))
    }
}

$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Host "saved: $Out"
