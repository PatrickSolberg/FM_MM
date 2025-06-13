# ⚽ FM_MM - Football Manager Mod Manager (PowerShell 7+)
# Supports CLI args, rar extraction via 7-Zip, retry logic, wildcard matching


[CmdletBinding()]
param (
    [switch]$auto,
    [string[]]$install
)

# ---------------------- Helper: ConvertTo-Hashtable -----------------------
function ConvertTo-Hashtable {
    param([PSObject]$inputObject)
    $hash = @{}
    foreach ($property in $inputObject.PSObject.Properties) {
        $hash[$property.Name] = $property.Value
    }
    return $hash
}

# ---------------------- Helper: Get-7ZipPath -----------------------
function Get-7ZipPath {
    $paths = @(
        "${env:ProgramFiles}\7-Zip\7z.exe",
        "${env:ProgramFiles(x86)}\7-Zip\7z.exe",
        "${env:LocalAppData}\Programs\7-Zip\7z.exe"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) {
            return $path
        }
    }
    return $null
}

# ---------------------- Path Setup -----------------------
$downloadsPath = "$env:USERPROFILE\Downloads"
$fmFolder = "$env:USERPROFILE\Documents\Sports Interactive\Football Manager 2024"
$jsonPath = "$PSScriptRoot\resources.json"
$logPath = "$env:USERPROFILE\Documents\Sports Interactive\Football Manager 2024\installed_resources.json"
$sevenZip = Get-7ZipPath

# ---------------------- Load JSON -----------------------
if (-not (Test-Path $jsonPath)) {
    Write-Host "❌ resources.json not found!" -ForegroundColor Red
    exit
}
$resourcesData = Get-Content $jsonPath | ConvertFrom-Json
$resources = $resourcesData.resources

# ---------------------- Load installed log -----------------------
$installed = @{}
if (Test-Path $logPath) {
    $installed = Get-Content $logPath | ConvertFrom-Json | ForEach-Object { $_ } | ConvertTo-Hashtable
}

# ---------------------- Main Loop -----------------------
foreach ($res in $resources) {
    $id = $res.id
    $category = $res.category

    if ($installed.PSObject.Properties.Name -contains $id) {
        Write-Host "✅ Already installed: $($res.name)"
        continue
    }

    if ($install.Count -gt 0 -and ($install -notcontains $category)) {
        continue
    }

    Write-Host "`n📦 Resource: $($res.name)" -ForegroundColor Cyan
    Write-Host "   🔗 Source: $($res.credit)"
    if ($res.note) {
        Write-Host "   📝 Note: $($res.note)" -ForegroundColor DarkGray
    }

    if (-not $auto) {
        $go = Read-Host "Install this resource? (y/n)"
        if ($go -ne 'y') { continue }
    }

    $targetFolder = Join-Path $fmFolder $res.installPath
    if (-not (Test-Path $targetFolder)) {
        New-Item -Path $targetFolder -ItemType Directory -Force | Out-Null
    }

    switch ($res.type) {
        "manual_browser" {
            Write-Host "🌐 Opening browser for manual download..."
            Start-Process $res.url
            if (-not $auto) {
                $mark = Read-Host "Mark this as installed manually? (y/n)"
                if ($mark -ne 'y') { continue }
            }
            $installed[$id] = @{
                name         = $res.name
                installed_at = (Get-Date).ToString("s")
                source       = $res.url
                method       = "manual_browser"
            }
            continue
        }

        "manual" {
            Start-Process $res.url
            $pattern = $res.expectedFilePattern
            $foundFile = $null
            $timeout = 600
            $timer = 0

            Write-Host "⏳ Waiting for file matching: $pattern"

            while (-not $foundFile) {
                $foundFile = Get-ChildItem -Path $downloadsPath -Filter $pattern -ErrorAction SilentlyContinue | Select-Object -First 1
                Start-Sleep -Seconds 3
                $timer += 3
                if ($timer -ge $timeout) {
                    Write-Host "`n⏱️ Timeout waiting for: $pattern" -ForegroundColor Yellow
                    $retry = Read-Host "Try again? (y/n)"
                    if ($retry -eq 'y') {
                        $timer = 0
                        continue
                    } else {
                        continue 2
                    }
                }
                Write-Host "." -NoNewline
            }
            Write-Host "`n✅ Found: $($foundFile.Name)"

            $ext = [System.IO.Path]::GetExtension($foundFile.Name)
            $destinationPath = Join-Path $targetFolder $foundFile.Name
            try {
                if ($ext -eq ".zip") {
                    Expand-Archive -Path $foundFile.FullName -DestinationPath $targetFolder -Force -ErrorAction Stop
                } elseif ($ext -eq ".rar") {
                    if (-not $sevenZip) {
                        Write-Host "`n❌ 7-Zip not found. Cannot extract .rar" -ForegroundColor Red
                        continue
                    }
                    & "$sevenZip" x $foundFile.FullName "-o$targetFolder" -y | Out-Null
                } else {
                    Move-Item -Path $foundFile.FullName -Destination $destinationPath -Force
                }
            } catch {
                Write-Host "❌ Installation failed: $_" -ForegroundColor Red
                continue
            }

            $installed[$id] = @{
                name         = $res.name
                installed_at = (Get-Date).ToString("s")
                source       = $res.url
                method       = "manual"
            }
            Write-Host "✅ Installed $($res.name)!" -ForegroundColor Green
        }

        default {
            Write-Host "❌ Unsupported type: $($res.type)" -ForegroundColor Red
        }
    }
}

# ---------------------- Save install log -----------------------
$installed | ConvertTo-Json -Depth 5 | Set-Content $logPath
Write-Host "`n📝 Installed resources saved to: installed_resources.json"
