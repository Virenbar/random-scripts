$t = Get-Date

$day = [int] $t.DayOfWeek
$hour = $t.Hour

Write-Host "$day $hour"

if (  1, 2, 3, 4, 5 -contains $day -and 
    ($hour -gt 9 -and $hour -lt 17)
) {
    Write-Host "true $day"
}
else {
    Write-Host "false $day"
}