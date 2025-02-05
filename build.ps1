[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet("podman", "docker")]
    [string] $ContainerEngine = "podman"
)

# Check if the container engine exists
# Exit early if the container engine is not installed
if (![string]::IsNullOrWhiteSpace($ContainerEngine)) {
    $containerEnginePath = Get-Command $ContainerEngine -ErrorAction SilentlyContinue
    if ($null -eq $containerEnginePath) {
        Write-Host "❌ Container engine $ContainerEngine not installed. Exiting..."
        exit 1
    }
    else {
        Write-Host "✅ Container engine $ContainerEngine found at $containerEnginePath."
    }
}

if ($ContainerEngine -eq "podman") {
    Write-Host "🐳 Using Podman as the container engine."
    $containerEngineCommand = "podman"
}
else {
    Write-Host "🐳 Using Docker as the container engine."
    $containerEngineCommand = "docker"
}

# Clear any existing error codes
$LASTEXITCODE = 0

# Build the container image
Write-Host "🔨 Building the container image..."
& $containerEngineCommand build -t trimui-toolchain .

# Check if the container image was built successfully
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build the container image. Exiting..."
    exit 1
}
else {
    Write-Host "✅ Container image built successfully."
}