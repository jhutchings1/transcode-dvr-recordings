param(
  [string] $path
)

foreach ($mpg in (Get-ChildItem -Path $path -Recurse | Where-Object {$_.Extension -eq ".mpg"})) {
  Write-host "Testing $($mpg.FullName)"
  $mp4s = (Get-ChildItem -Path $path -Recurse | Where-Object {$_.Extension -eq ".mp4" -and $_.BaseName -eq $mpg.BaseName})
  if ($mp4s.Length -gt 0) {
    write-host "Found $($mp4s[0].FullName)"
    rm $mpg.FullName
  }
}