$date = Get-Date -Format 'yyyy.MM.dd'
$bin_ver     = "$date.{0:D2}" -f ($env:GITHUB_RUN_NUMBER % 100)
$release_ver = "$date+{0:D2}" -f ($env:GITHUB_RUN_NUMBER % 100)

Write-Output bin_ver=$bin_ver
Write-Output release_ver=$release_ver
echo "bin_ver=$bin_ver" >> $env:GITHUB_OUTPUT
echo "release_ver=$release_ver" >> $env:GITHUB_OUTPUT
