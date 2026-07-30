$date = Get-Date -Format 'yyyy.MM.dd'
$build_num   = ($env:GITHUB_RUN_NUMBER -as [int]) % 100
$bin_ver     = "$date.$build_num"
$release_ver = "$date-$build_num"

Write-Output bin_ver=$bin_ver
Write-Output release_ver=$release_ver
echo "bin_ver=$bin_ver" >> $env:GITHUB_OUTPUT
echo "release_ver=$release_ver" >> $env:GITHUB_OUTPUT
