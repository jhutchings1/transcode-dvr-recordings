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
  $output = "ffmpeg -hide_banner "
  if ($hwaccel) {
    $output += "-hwaccel auto "
  }
  $output += "-i `"$($inputName)`" "
  $output += "-n -c:v libx265 -crf 32 -preset medium -acodec aac "
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
