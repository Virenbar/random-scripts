[Environment]::CurrentDirectory = $PSScriptRoot

$MSBuild = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe'
& $MSBuild '.\<ProjectFolder>\<Project>.vbproj' /t:Restore /t:Build /v:m /p:Configuration=Release

$Version = [System.Reflection.Assembly]::LoadFrom(".\<ProjectFolder>\bin\Release\<Project>.exe").GetName().Version
Write-Host "Версия сборки: $Version"

Write-Host 'Архивация приложения'
$compress = @{
    Path             = '.\<ProjectFolder>\bin\Release\*'
    CompressionLevel = 'Fastest'
    DestinationPath  = '\\{RemoteFolder}\AutoUpdate\Latest.zip'
}
Compress-Archive @compress -Force

$VersionFile = '\\{RemoteFolder}\AutoUpdate\Version.xml'
$XML = New-Object XML
$XML.Load($VersionFile)
$V = $XML.SelectSingleNode('//version')
if ($V.InnerText -eq $Version) { Write-Warning "Версия не изменена: $Version" }
else {
    $V.InnerText = $Version
    $XML.Save($VersionFile)
    Write-Host "Версия изменена: $Version"
}
#Write-Host "Moving to remote"
#Move-Item -Path ".\Latest.zip" -Destination "\\{RemoteFolder}\AutoUpdate" -Force
Write-Host "Публикация завершена"
[Console]::ReadKey($True)