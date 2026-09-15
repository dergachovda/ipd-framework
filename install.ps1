# install.ps1 — deploy the ipd-framework Copilot CLI skills to ~/.copilot/skills/
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# init-ipd skill — scaffolds .ipd/ into a repo (one-shot setup)
$initDest = "$env:USERPROFILE\.copilot\skills\init-ipd"
New-Item -ItemType Directory -Force $initDest | Out-Null
Copy-Item "$scriptDir\src\skills\init-ipd\SKILL.md" "$initDest\SKILL.md" -Force
Copy-Item "$scriptDir\src\skills\init-ipd\init-ipd.sh" "$initDest\init-ipd.sh" -Force

# ipd skill — runtime router; surfaces gitignored ./.ipd/ to agents
$ipdDest = "$env:USERPROFILE\.copilot\skills\ipd"
New-Item -ItemType Directory -Force $ipdDest | Out-Null
Copy-Item "$scriptDir\src\skills\ipd\SKILL.md" "$ipdDest\SKILL.md" -Force

$scriptsDest = "$env:USERPROFILE\.ipd-framework\scripts"
New-Item -ItemType Directory -Force $scriptsDest | Out-Null
Copy-Item "$scriptDir\src\scripts\init-ipd.sh" "$scriptsDest\init-ipd.sh" -Force
Copy-Item "$scriptDir\src\scripts\get-next-ipd-id.sh" "$scriptsDest\get-next-ipd-id.sh" -Force
Copy-Item "$scriptDir\src\scripts\session-status.sh" "$scriptsDest\session-status.sh" -Force

$templatesDest = "$env:USERPROFILE\.ipd-framework\templates"
New-Item -ItemType Directory -Force $templatesDest | Out-Null
Copy-Item "$scriptDir\src\templates\*" $templatesDest -Force

Write-Host ""
Write-Host "✅ ipd-framework skills installed."
Write-Host "   Skills:    $initDest"
Write-Host "             $ipdDest"
Write-Host "   Scripts:   $scriptsDest"
Write-Host "   Templates: $templatesDest"
Write-Host ""
Write-Host "Open a repo and run: init-ipd   (one-time setup)"
Write-Host "Then operate with:   /ipd <new|plan|work|done|status|help>"
