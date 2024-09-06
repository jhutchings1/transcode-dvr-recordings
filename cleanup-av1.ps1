param(
  [string] $path
)

$transcodedFiles = (Get-ChildItem -Path $path -Recurse | Where-Object {$_.BaseName.Contains("-AV1")})
Write-Host "Found $($transcodedFiles.Length) transcoded files"

foreach ($transcoded in $transcodedFiles) {
  Write-host "Found $($transcoded.FullName)"

  # Look for files that have a name which is the same as the transcoded file, but without the -AV1 suffix
  $pattern = $transcoded.BaseName -replace "-AV1", ""
  Write-host "Looking for files that match $pattern"

  $sources = (Get-ChildItem -Path $path -Recurse | Where-Object {$_.BaseName -eq $pattern})
  # If we find a file that matches the pattern, delete the source file, then rename the transcoded file to the source file name
  if ($sources.Length -gt 0) {
    write-host "Found $($sources[0].FullName)"
    rm $sources[0].FullName
    mv $transcoded.FullName $sources[0].FullName
  }
}
