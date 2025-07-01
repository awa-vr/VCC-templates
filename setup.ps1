# Check if DotNet SDK is installed
$dotnetInstalled = $false
try {
    $version = dotnet --version
    if ($version) {
        $dotnetInstalled = $true
        Write-Host ".NET SDK is already installed. Version: $version"
    }
}
catch {
    # If dotnet is not recognized as a command, it's not installed
}

# Install DotNet SDK
if (-not $dotnetInstalled) {
    Write-Host ".NET SDK is not installed. Installing..."
    winget install Microsoft.dotNet.SDK.8
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error installing .NET SDK"
        exit 1
    }
}

# Check if VPM CLI is installed
$vpmInstalled = $false
try {
    $version = vpm --version
    if ($version) {
        $vpmInstalled = $true
        Write-Host "VPM is already installed. Version: $version"
    }
}
catch {
    # If vpm is not recognized as a command, it's not installed
}

# Install VPM
if (-not $vpmInstalled) {
    Write-Host "VPM is not installed. Installing..."
    dotnet tool install --global vrchat.vpm.cli
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error installing VPM"
        exit 1
    }
}

# Add the following repos to VCC:
$repos = @(
    "https://awa-vr.github.io/vrc-tools-vpm/index.json",
    "https://rurre.github.io/vpm/index.json",
    "https://whiteflare.github.io/vpm-repos/vpm.json",
    "https://vpm.thry.dev/index.json",
    "https://vpm.razgriz.one/index.json",
    "https://gabsith.github.io/GabSith-VCC-Listing/index.json"
    "https://vcc.vrcfury.com",
    "https://poiyomi.github.io/vpm/index.json",
    "https://adjerry91.github.io/VRCFaceTracking-Templates/index.json"
)

foreach ($item in $repos) {
    Write-Host "Adding $item to VCC"
    vpm add repo $item
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