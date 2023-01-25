#[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[Console]::outputEncoding = [System.Text.Encoding]::GetEncoding('cp866')
Write-Host "Распаковка <AppName>"
Expand-Archive -Path '\\{RemoteFolder}\AutoUpdate\Latest.zip' -DestinationPath "$env:APPDATA\<AppName>" -Force
$DesktopPath = [Environment]::GetFolderPath("Desktop")

Write-Host "Создание ярлыка"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$DesktopPath\<AppName> (Portable).lnk")
$Shortcut.TargetPath = "$env:APPDATA\<AppName>\<AppName>.exe"
$Shortcut.Save()

Write-Host "Установка завершена"
Write-Host "Вы можете закрыть это окно"
[Console]::ReadKey($True)