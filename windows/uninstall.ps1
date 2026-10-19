# Removes WriteNow from this computer.
$dest = Join-Path $env:LOCALAPPDATA 'Programs\WriteNow'
Get-CimInstance Win32_Process -Filter "Name='msedge.exe'" -ErrorAction SilentlyContinue |
  Where-Object { $_.CommandLine -like '*Programs\WriteNow*' } |
  ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
Remove-Item (Join-Path ([Environment]::GetFolderPath('Programs')) 'WriteNow.lnk') -ErrorAction SilentlyContinue
Remove-Item (Join-Path ([Environment]::GetFolderPath('Desktop'))  'WriteNow.lnk') -ErrorAction SilentlyContinue
Remove-Item 'HKCU:\Software\Classes\WriteNow.pdf' -Recurse -ErrorAction SilentlyContinue
Remove-ItemProperty 'HKCU:\Software\Classes\.pdf\OpenWithProgids' -Name 'WriteNow.pdf' -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue
Write-Host 'WriteNow has been removed.'
