$date = Get-Date -Format 'yyyy.MM.dd'
$bin_ver     = "$date.0"
$release_ver = "$date+$env:GITHUB_RUN_NUMBER"

Write-Output bin_ver=$bin_ver
Write-Output release_ver=$release_ver
echo "bin_ver=$bin_ver" >> $env:GITHUB_OUTPUT
echo "release_ver=$release_ver" >> $env:GITHUB_OUTPUT
