param(
  [string] $path
)

# Loops through all of the files in the $dvrRoot directory where the extension is .mpg
# Calls ffmpeg to convert from mpeg-2 to mpeg-4
foreach ($file in (Get-ChildItem -Path $path -Recurse | Where-Object {$_.Extension -eq ".mpg" -and $_.DirectoryName -notcontains "finished"})) {
  $finished = $null
  if (Test-Path "$($file.DirectoryName)/finished") {
    $finished = Get-Item -Path "$($file.DirectoryName)/finished"
  } else {
    # Create a directory for finished files
    $finished = New-Item -Path "$($file.DirectoryName)/finished" -ItemType Directory 
  }
  #Convert the file
  Invoke-Expression "ffmpeg -i `"$($file.FullName)`" `"$($finished.FullName)/$($file.BaseName).mp4`" -n" 
}
