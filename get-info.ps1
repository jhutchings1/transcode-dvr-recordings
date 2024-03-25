param(
  [string] $path
)


$items = (Get-ChildItem -Path $path | Where-Object { $_.Extension -eq ".mp4" -or $_.Extension -eq ".mpg" })
$outputItems = @()

foreach ($item in $items) {
    $outputItem = New-Object PSObject
    $data = (Invoke-Expression "ffprobe -v error -pretty -show_streams -show_format -of json ""$($item.FullName)""")
    $data = $data | ConvertFrom-Json
    $data.streams | Where-Object { $_.codec_type -eq "video" } | Select-Object -First 1 | ForEach-Object {
        $outputItem | Add-Member -MemberType NoteProperty -Name "File" -Value $item.FullName
        $outputItem | Add-Member -MemberType NoteProperty -Name "Width" -Value $_.width
        $outputItem | Add-Member -MemberType NoteProperty -Name "Height" -Value $_.height
        $outputItem | Add-Member -MemberType NoteProperty -Name "Duration" -Value $_.duration
        $outputItem | Add-Member -MemberType NoteProperty -Name "Codec" -Value $_.codec_name
        $outputItem | Add-Member -MemberType NoteProperty -Name "FileSize" -Value $item.Size
    $outputItems += $outputItem
    }
}
$outputItems