

# Use vrc-get instead of vpm/dotnet. Download latest x86_64 Windows vrc-get executable if missing
$toolsDir = Join-Path $env:LOCALAPPDATA 'VRChatCreatorCompanion\Templates\tools'
$exeName = 'x86_64-pc-windows-msvc-vrc-get.exe'
$vrcGetPath = Join-Path $toolsDir $exeName

if (-not (Test-Path $vrcGetPath)) {
    Write-Host "vrc-get not found. Downloading latest vrc-get..."
    if (-not (Test-Path $toolsDir)) { New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null }

    $downloadUrl = 'https://github.com/vrc-get/vrc-get/releases/latest/download/x86_64-pc-windows-msvc-vrc-get.exe'
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $vrcGetPath -UseBasicParsing -ErrorAction Stop
        Write-Host "Downloaded vrc-get to $vrcGetPath"
    }
    catch {
        Write-Host "Failed to download vrc-get from $downloadUrl"
        Write-Host $_
        exit 1
    }
}

# Verify vrc-get is runnable
try {
    $version = & $vrcGetPath --version 2>$null
    if ($version) { Write-Host "vrc-get available: $version" }
}
catch {
    Write-Host "vrc-get could not be executed. Please ensure the downloaded file is valid: $vrcGetPath"
    Write-Host $_
    exit 1
}

# Add the following repos to VCC using vrc-get:
$repos = @(
    "https://awa-vr.github.io/vrc-tools-vpm/index.json",
    "https://rurre.github.io/vpm/index.json",
    "https://whiteflare.github.io/vpm-repos/vpm.json",
    "https://vpm.thry.dev/index.json",
    "https://vpm.razgriz.one/index.json",
    "https://gabsith.github.io/GabSith-VCC-Listing/index.json",
    "https://vcc.vrcfury.com",
    "https://poiyomi.github.io/vpm/index.json",
    "https://adjerry91.github.io/VRCFaceTracking-Templates/index.json",
    "https://hai-vr.github.io/vpm-listing/index.json",
    "https://wholesomevr.github.io/SPS-Configurator/index.json",
    "https://wholesomevr.github.io/vpm/index.json",
    "https://spokeek.github.io/goloco/index.json",
    "https://hfcred.github.io/VPM-Listing/index.json"
)

foreach ($item in $repos) {
    Write-Host "Adding repo \"$item\" to VCC"
    try {
        & $vrcGetPath repo add $item
        if ($LASTEXITCODE -ne 0) { Write-Host "Failed to add $item (exit code $LASTEXITCODE)" }
        else { Write-Host "Added $item" }
    }
    catch {
        Write-Host "Error running vrc-get for $item"
        Write-Host $_
    }
}

# Copy the templates
Write-Host "Copying templates"
$templates = @(
    "AwA Avatar Template"
)

# Create the Templates folder if it doesn't exist
$templatesFolder = "$env:LOCALAPPDATA\VRChatCreatorCompanion\Templates"
if (-not (Test-Path $templatesFolder)) {
    New-Item -ItemType Directory -Path $templatesFolder
}

# Copy all files
foreach ($item in $templates) {
    Copy-Item -Path .\$item -Destination $env:LOCALAPPDATA\VRChatCreatorCompanion\Templates\ -Recurse
}

Write-Host "Setup complete"