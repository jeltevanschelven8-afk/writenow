# Installs WriteNow for the current user (no administrator rights needed).
# It opens in its own Edge window without an address bar, with its own Edge
# profile, and appears under "Open with" for PDF files.
$ErrorActionPreference = 'Stop'
$src  = $PSScriptRoot
$dest = Join-Path $env:LOCALAPPDATA 'Programs\WriteNow'

# Remove an older install under the previous name, if there is one
$old = Join-Path $env:LOCALAPPDATA 'Programs\Maarten Program'
Get-CimInstance Win32_Process -Filter "Name='msedge.exe'" -ErrorAction SilentlyContinue |
  Where-Object { $_.CommandLine -like '*Maarten Program*' } |
  ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
Start-Sleep -Seconds 1
Remove-Item $old -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path ([Environment]::GetFolderPath('Programs')) 'Maarten Program.lnk') -ErrorAction SilentlyContinue
Remove-Item (Join-Path ([Environment]::GetFolderPath('Desktop'))  'Maarten Program.lnk') -ErrorAction SilentlyContinue
Remove-Item 'HKCU:\Software\Classes\MaartenProgram.pdf' -Recurse -ErrorAction SilentlyContinue
Remove-ItemProperty 'HKCU:\Software\Classes\.pdf\OpenWithProgids' -Name 'MaartenProgram.pdf' -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Force $dest | Out-Null
foreach ($f in 'index.html', 'WriteNow.ico') {
  Copy-Item (Join-Path $src $f) $dest -Force
}

$edge = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
          "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") |
        Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw 'Microsoft Edge was not found.' }

$icon    = Join-Path $dest 'WriteNow.ico'
$url     = ([System.Uri](Join-Path $dest 'index.html')).AbsoluteUri
# A separate profile keeps WriteNow apart from your normal Edge and lets it
# read a PDF that you open with it.
$profile = Join-Path $dest 'profile'
$common  = "--user-data-dir=`"$profile`" --no-first-run --no-default-browser-check --disable-sync --allow-file-access-from-files --window-size=1200,860"

# Shortcuts in the Start menu and on the desktop
$shell = New-Object -ComObject WScript.Shell
$links = @(
  (Join-Path ([Environment]::GetFolderPath('Programs')) 'WriteNow.lnk'),
  (Join-Path ([Environment]::GetFolderPath('Desktop'))  'WriteNow.lnk')
)
foreach ($path in $links) {
  $l = $shell.CreateShortcut($path)
  $l.TargetPath       = $edge
  $l.Arguments        = "$common --app=`"$url`""
  $l.IconLocation     = "$icon,0"
  $l.WorkingDirectory = $dest
  $l.Description      = 'WriteNow'
  $l.Save()
}

# "Open with > WriteNow" for PDF files (this user only; your default PDF app stays the same)
$classes = 'HKCU:\Software\Classes'
$progId  = "$classes\WriteNow.pdf"
New-Item -Force "$progId\shell\open\command" | Out-Null
New-Item -Force "$progId\DefaultIcon" | Out-Null
Set-Item "$progId" 'PDF document (WriteNow)'
Set-Item "$progId\DefaultIcon" "`"$icon`""
Set-Item "$progId\shell\open\command" "`"$edge`" $common --app=`"$url`?pdf=%1`""
New-ItemProperty -Force "$progId\shell\open" -Name FriendlyAppName -Value 'WriteNow' | Out-Null
New-ItemProperty -Force "$progId\shell\open" -Name Icon -Value "`"$icon`"" | Out-Null
New-Item -Force "$progId\Application" | Out-Null
New-ItemProperty -Force "$progId\Application" -Name ApplicationName -Value 'WriteNow' | Out-Null
New-ItemProperty -Force "$progId\Application" -Name ApplicationIcon -Value "`"$icon`"" | Out-Null
New-Item -Force "$classes\.pdf\OpenWithProgids" | Out-Null
New-ItemProperty -Force "$classes\.pdf\OpenWithProgids" -Name 'WriteNow.pdf' -Value '' | Out-Null

# Tell Explorer that something changed
Add-Type -Namespace WinApi -Name Shell -MemberDefinition '[DllImport("shell32.dll")] public static extern void SHChangeNotify(int e, int f, IntPtr a, IntPtr b);'
[WinApi.Shell]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)

Write-Host "WriteNow is installed in $dest"
Write-Host 'Find it in the Start menu and on your desktop.'
Write-Host 'To open a PDF: right-click a PDF > Open with > WriteNow.'
