# Simple FM Resource Installer - PowerShell 7 Compatible

# Settings
$fmFolder = "$env:USERPROFILE\Documents\Sports Interactive\Football Manager 2024"
$graphicsFolder = Join-Path $fmFolder "graphics"
$skinsFolder = Join-Path $graphicsFolder "skins"
$tempFile = "$env:TEMP\example-skin.zip"

# Example Resource
$resourceName = "Example Skin"
$resourceType = "Skin"
$downloadUrl = ""  # Replace with real link

# Prompt user
Write-Host "`n📦 You're about to download: $resourceName ($resourceType)" -ForegroundColor Cyan
$confirm = Read-Host "Do you want to continue? (y/n)"
if ($confirm -ne "y") {
    Write-Host "❌ Aborted by user." -ForegroundColor Yellow
    exit
}

# Check FM folders
if (-not (Test-Path $fmFolder)) {
    Write-Host "⚠️ FM24 folder not found at expected path: $fmFolder"
    exit
}
if (-not (Test-Path $skinsFolder)) {
    Write-Host "📁 Skins folder not found. Creating it..."
    New-Item -Path $skinsFolder -ItemType Directory | Out-Null
}

# Download with basic progress
Write-Host "`n⬇️ Downloading $resourceName..."
$response = Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile -UseBasicParsing

# Confirm download success
if (-not (Test-Path $tempFile)) {
    Write-Host "❌ Download failed or file not found." -ForegroundColor Red
    exit
}

# Extract
Write-Host "🗂️ Extracting to: $skinsFolder..."
try {
    Expand-Archive -Path $tempFile -DestinationPath $skinsFolder -Force
} catch {
    Write-Host "❌ Extraction failed: $_" -ForegroundColor Red
    Write-Host "Please try to extract it manually." -ForegroundColor Yellow
    exit
}

# Done
Write-Host "`n✅ $resourceName has been installed successfully!" -ForegroundColor Green
Write-Host "➡️ In FM24, go to Preferences > Interface and reload the skin."
