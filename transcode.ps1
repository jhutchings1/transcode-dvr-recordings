$dvrRoot = "" # Set the appropriate root directory for your DVR here
cd $dvrRoot

# Loops through all of the files in the $dvrRoot directory where the extension is .mpg
# Calls ffmpeg to convert from mpeg-2 to mpeg-4
foreach ($file in (Get-ChildItem -Recurse | Where-Object {$_.Extension -eq ".mpg"})) {
  Invoke-Expression "ffmpeg -i `"$($file.Name)`" `"$($file.BaseName).mp4`""
}
