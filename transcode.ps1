param(
  [string] $path
)

# Loops through all of the files in the $dvrRoot directory where the extension is .mpg
# Calls ffmpeg to convert from mpeg-2 to mpeg-4
foreach ($file in (Get-ChildItem -Path $path -Recurse | Where-Object {$_.Extension -eq ".mpg" -and $_.DirectoryName -notcontains "finished"})) {
  # Create a directory for finished files
  $finished = New-Item -Path "$($file.DirectoryName)/finished" -ItemType Directory -ErrorAction SilentlyContinue

  #Convert the file
  Invoke-Expression "ffmpeg -i `"$($file.FullName)`" `"$($finished.FullName)/$($file.BaseName).mp4`" -n" 
  
  # Move the old file to the finished directory
  Move-Item -Path $file.Name -Destination "$($finished.FullName)/$($file.Name)"
}
