param(
  [string] $path
)

function createFinishedPath($file) {
  $finishedPath = $null
  if (Test-Path "$($file.DirectoryName)/finished") {
    $finishedPath = Get-Item -Path "$($file.DirectoryName)/finished"
  } else {
    # Create a directory for finished files
    $finishedPath = New-Item -Path "$($file.DirectoryName)/finished" -ItemType Directory 
  }
  return $finishedPath
}

# Loops through all of the files in the $dvrRoot directory where the extension is .mpg
# Calls ffmpeg to convert from mpeg-2 to mpeg-4

foreach ($file in (Get-ChildItem -Path $path -Recurse | Where-Object {$_.Extension -eq ".mpg" -and $_.DirectoryName -notcontains "finished"})) {
  $finishedPath = createFinishedPath($file)
  
  if (!(Test-Path "$($finishedPath.FullName)/$($file.BaseName).mp4")) {
    #Convert the file
    Invoke-Expression "ffmpeg -hide_banner -hwaccel auto -i `"$($file.FullName)`" `"$($finishedPath.FullName)/$($file.BaseName).mp4`" -n -vcodec libx265 -acodec aac" 
  }
}
