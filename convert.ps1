param(
  [string] $path
)

$preset = "HQ 2160p60 4K AV1 Surround"
$items = ./get-info.ps1 $path | Where-Object {$_.codec -eq "mpeg2video"}

foreach ($item in $items) {
    echo "Converting $($item.FullName)"
    $file = Get-Item $item.File

    ./HandbrakeCLI.exe --preset $preset -i $file.FullName -o "$(file.Directory.FullName)/$($file.BaseName)-$($item.height)-av1.mp4"
}