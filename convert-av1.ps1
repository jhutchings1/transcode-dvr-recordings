param(
  [string] $path
)

$items = ./get-info.ps1 $path | Where-Object {$_.codec -eq "mpeg2video" -or $_.codec -eq "h264"}

foreach ($item in $items) {
    echo "Converting $($item.FullName)"
    $file = Get-Item $item.File

    ffmpeg -i $file.FullName -c:v libsvtav1 -preset 5 -crf 35 -c:a copy -n -hide_banner "$($file.Directory.FullName)/$($file.BaseName)-AV1.mp4"
    # Remove the old file, then rename the new file to the old file's name
    rm $file.FullName
    mv "$($file.Directory.FullName)/$($file.BaseName)-AV1.mp4" $file.FullName
}