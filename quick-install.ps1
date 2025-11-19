# Hızlı Kurulum Scripti
$ErrorActionPreference = "Stop"

Write-Host "LazyVim ve Wezterm Hizli Kurulum" -ForegroundColor Cyan
Write-Host ""

# 1. LazyVim
Write-Host "[1/3] LazyVim kuruluyor..." -ForegroundColor Yellow
$nvimDest = Join-Path $env:LOCALAPPDATA "nvim"
$currentDir = $PSScriptRoot

if (Test-Path $nvimDest) {
    $backup = "$nvimDest.backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
    Move-Item $nvimDest $backup -Force
    Write-Host "  Yedek: $backup" -ForegroundColor Gray
}

New-Item -ItemType Directory -Path $nvimDest -Force | Out-Null

# Ana dosyaları kopyala
Copy-Item (Join-Path $currentDir "init.lua") -Destination $nvimDest -Force
Copy-Item (Join-Path $currentDir "lazy-lock.json") -Destination $nvimDest -Force
Copy-Item (Join-Path $currentDir "lazyvim.json") -Destination $nvimDest -Force
Copy-Item (Join-Path $currentDir "stylua.toml") -Destination $nvimDest -Force -ErrorAction SilentlyContinue

# lua klasörü
Copy-Item (Join-Path $currentDir "lua") -Destination $nvimDest -Recurse -Force

Write-Host "  OK: $nvimDest" -ForegroundColor Green
Write-Host ""

# 2. Wezterm
Write-Host "[2/3] Wezterm kuruluyor..." -ForegroundColor Yellow
$weztermSrc = Join-Path $currentDir "wezterm\wezterm.lua"
$weztermDest = Join-Path $env:USERPROFILE ".wezterm.lua"

if (Test-Path $weztermDest) {
    $backup = "$weztermDest.backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
    Move-Item $weztermDest $backup -Force
    Write-Host "  Yedek: $backup" -ForegroundColor Gray
}

Copy-Item $weztermSrc -Destination $weztermDest -Force
Write-Host "  OK: $weztermDest" -ForegroundColor Green
Write-Host ""

# 3. PowerShell Profil
Write-Host "[3/3] PowerShell profili kuruluyor..." -ForegroundColor Yellow
$profileSrc = Join-Path $currentDir "wezterm\powershell\Microsoft.PowerShell_profile.ps1"
$profileDest = $PROFILE

$profileDir = Split-Path $profileDest -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (Test-Path $profileDest) {
    $backup = "$profileDest.backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
    Move-Item $profileDest $backup -Force
    Write-Host "  Yedek: $backup" -ForegroundColor Gray
}

Copy-Item $profileSrc -Destination $profileDest -Force
Write-Host "  OK: $profileDest" -ForegroundColor Green
Write-Host ""

Write-Host "Kurulum tamamlandi!" -ForegroundColor Green
Write-Host ""
Write-Host "Sonraki adimlar:" -ForegroundColor Yellow
Write-Host "  1. nvim     (Neovim'i baslat)"
Write-Host "  2. wezterm  (WezTerm'i baslat)"
Write-Host ""
