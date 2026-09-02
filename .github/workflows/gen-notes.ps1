[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$previous_tag = $(git describe --tags --abbrev=0 HEAD^ 2>$null)
if ($previous_tag -ne $null -and $previous_tag -ne '') {
    $previous_tag += '..HEAD'
}
$repo_url = "$env:GITHUB_SERVER_URL/$env:GITHUB_REPOSITORY"
$release_body = $(git log "$previous_tag" --pretty=format:"- [``%h``]($repo_url/commit/%H): %s  %n")
$release_body = $release_body `
    -replace '(?<=: ).*(新增|加入|引入|更新)', '🔨$&' `
    -replace '(?<=: ).*删除', '✂️$&' `
    -replace '(?<=: ).*(修改|调整|更换)', '🔧$&' `
    -replace '(?<=: ).*修复', '🪛$&' `
    -replace '(?<=: ).*(优化|改进)', '🚀$&' `
    -replace '(?<=: ).*(重构|重写)', '⚙️$&' `

Write-Output previous_tag=$previous_tag
Write-Output release_body=$release_body
echo $release_body > CHANGELOG.md
