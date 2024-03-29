param(
  [string] $path,
  [bool] $hwaccel
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

function createFFMPEGExpression($inputName, $outputName, $hwaccel) {
  $output = "ffmpeg "
  if ($hwaccel) {
    $output += "-hwaccel auto "
  }
  $output += "-i `"$($inputName)`" "
  # Obtained from https://alfg.dev/ffmpeg-commander/
  $output += "-c:v libx265 -preset medium -crf 23 -c:a copy -n -hide_banner " 
  $output += "`"$($outputName)`" "

  return $output
}

# Loops through all of the files in the $dvrRoot directory where the extension is .mpg
# Calls ffmpeg to convert from mpeg-2 to mpeg-4

foreach ($file in (Get-ChildItem -Path $path -Recurse | Where-Object {$_.Extension -eq ".mpg"})) {
  $outputFile = "$($file.DirectoryName)/$($file.BaseName).mp4"
  
  if (!(Test-Path $outputFile)) {
    $expression = createFFMPEGExpression $file.FullName "$outputFile" $hwaccel;
    
    #Convert the file
    Write-Host "Converting $($file.FullName)"
    Invoke-Expression $expression
  }
}
