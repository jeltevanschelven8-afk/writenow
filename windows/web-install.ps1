# One-line installer for WriteNow. Paste this into Windows PowerShell:
#
#   irm https://raw.githubusercontent.com/jeltevanschelven8-afk/writenow/main/windows/web-install.ps1 | iex
#
# It downloads the latest WriteNow-for-Windows.zip into a temporary folder and runs
# its install.ps1. Because no downloaded script file is opened by Windows, this also
# works when Smart App Control blocks downloaded .cmd or .ps1 files.
& {
  $ErrorActionPreference = 'Stop'
  $ProgressPreference = 'SilentlyContinue'
  $zipUrl = 'https://github.com/jeltevanschelven8-afk/writenow/raw/main/dist/WriteNow-for-Windows.zip'
  $tmp = Join-Path $env:TEMP ('WriteNow-' + [guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory $tmp | Out-Null
  try {
    Write-Host 'Downloading WriteNow...'
    Invoke-WebRequest $zipUrl -OutFile (Join-Path $tmp 'WriteNow.zip') -UseBasicParsing
    Expand-Archive (Join-Path $tmp 'WriteNow.zip') $tmp -Force
    $env:WN_SRC = Join-Path $tmp 'WriteNow-for-Windows'
    & ([scriptblock]::Create((Get-Content (Join-Path $env:WN_SRC 'install.ps1') -Raw)))
  }
  catch {
    Write-Host ''
    Write-Host ('Installation failed: ' + $_.Exception.Message) -ForegroundColor Red
    Write-Host 'Please report this at https://github.com/jeltevanschelven8-afk/writenow/issues'
  }
  finally {
    Remove-Item Env:WN_SRC -ErrorAction SilentlyContinue
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
  }
}
