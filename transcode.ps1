$dvrRoot = "" # Set the appropriate root directory for your DVR here
cd $dvrRoot

# Loops through all of the files in the $dvrRoot directory where the extension is .mpg
# Calls ffmpeg to convert from mpeg-2 to mpeg-4
foreach ($mpg in (Get-ChildItem -Recurse | Where-Object {$_.Extension -eq ".mpg" -and $_.DirectoryName -notcontains "finished"})) {
  # Create a directory for finished files
  $finishedDir = New-Item -Path "$($mpg.DirectoryName)/finished" -ItemType Directory -ErrorAction SilentlyContinue

  #Convert the file
  Invoke-Expression "ffmpeg -i `"$($mpg.Name)`" `"$($mpg.BaseName).mp4`" -n" 
  
  # Move the old file to the finished directory
  Move-Item -Path $mpg.Name -Destination "$($finishedDir.FullName)/$($mpg.Name)"
}
