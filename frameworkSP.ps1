$regPath = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP'

# Function to retrieve the installed .NET versions from the registry
function Get-InstalledDotNetVersions {
    $versions = Get-ChildItem -Path $regPath |
                Get-ItemProperty -name Version, Release -EA 0 |
                Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
                Select-Object -Property PSChildName, Version, Release

    return $versions
}

# Function to get the service pack level for a given .NET version
function Get-ServicePackLevel {
    param (
        [string]$version
    )

    $servicePack = 'None'

    # Check if the Release value indicates a service pack level
    if ($version -like '4.*') {
        $release = $version.Split('.')[2]
        $servicePack = "Service Pack $release"
    }
    elseif ($version -like '2.*' -or $version -like '3.0') {
        $servicePack = 'Service Pack 2'
    }
    elseif ($version -like '3.5.*') {
        $servicePack = 'Service Pack 1'
    }

    return $servicePack
}

# Main script
$installedVersions = Get-InstalledDotNetVersions

if ($installedVersions) {
    Write-Host "Installed .NET Framework Versions:"
    Write-Host "----------------------------------"
    foreach ($version in $installedVersions) {
        $servicePack = Get-ServicePackLevel -version $version.Version
        Write-Host "$($version.PSChildName): $($version.Version) $servicePack"
    }
}
else {
    Write-Host "No .NET Framework versions found."
}
