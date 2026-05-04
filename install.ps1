# install.ps1 — deploy the init-ipd Copilot CLI skill to ~/.copilot/skills/
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$dest = "$env:USERPROFILE\.copilot\skills\init-ipd"

New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item "$scriptDir\src\skills\init-ipd\SKILL.md" "$dest\SKILL.md" -Force
Copy-Item "$scriptDir\src\skills\init-ipd\init-ipd.sh" "$dest\init-ipd.sh" -Force

$scriptsDest = "$env:USERPROFILE\.ipd-framework\scripts"
New-Item -ItemType Directory -Force $scriptsDest | Out-Null
Copy-Item "$scriptDir\src\scripts\init-ipd.sh" "$scriptsDest\init-ipd.sh" -Force
Copy-Item "$scriptDir\src\scripts\get-next-ipd-id.sh" "$scriptsDest\get-next-ipd-id.sh" -Force
Copy-Item "$scriptDir\src\scripts\session-status.sh" "$scriptsDest\session-status.sh" -Force

$templatesDest = "$env:USERPROFILE\.ipd-framework\templates"
New-Item -ItemType Directory -Force $templatesDest | Out-Null
Copy-Item "$scriptDir\src\templates\*" $templatesDest -Force

Write-Host ""
Write-Host "✅ init-ipd skill installed."
Write-Host "   Skill:     $dest"
Write-Host "   Scripts:   $scriptsDest"
Write-Host "   Templates: $templatesDest"
Write-Host ""
Write-Host "Open a repo and run: init-ipd"
