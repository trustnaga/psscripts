$dotNetVersion = '4.0'

$regPath = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP'

# Function to check if .NET Framework 4.x is installed
function IsDotNet4Installed {
    $versionKey = Join-Path $regPath $dotNetVersion
    return (Test-Path $versionKey)
}

# Function to retrieve the installed applications that require .NET Framework 4.x
function GetApplicationsUsingDotNet4 {
    $applications = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE (Name LIKE '%.NET Framework 4%')"
    return $applications
}

# Main script
if (IsDotNet4Installed) {
    $applicationsUsingDotNet4 = GetApplicationsUsingDotNet4

    if ($applicationsUsingDotNet4) {
        Write-Host "Applications using .NET Framework 4.x:"
        Write-Host "--------------------------------------"

        foreach ($app in $applicationsUsingDotNet4) {
            Write-Host $app.Name
        }
    }
    else {
        Write-Host "No applications found that are using .NET Framework 4.x."
    }
}
else {
    Write-Host ".NET Framework 4.x is not installed."
}
