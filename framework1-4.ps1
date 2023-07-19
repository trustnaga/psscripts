Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' |
Where-Object { ($_.PSChildName -ne "v4") -and ($_.PSChildName -like 'v*') } |
ForEach-Object {
    $name = $_.Version
    $sp = $_.SP
    $install = $_.Install
    if (-not $install) {
        Write-Host -Object "$($_.PSChildName)  $($name)"
    }
    elseif ($install -eq '1') {
        if (-not $sp) {
            Write-Host -Object "$($_.PSChildName)  $($name)"
        }
        else {
            Write-Host -Object "$($_.PSChildName)  $($name) SP$($sp)"
        }
}
    if (-not $name) {
        $parentName = $_.PSChildName
        Get-ChildItem -LiteralPath $_.PSPath |
        Where-Object {
            if ($_.Property -contains 'Version') { $name = Get-ItemPropertyValue -Path $_.PSPath -Name Version }
            if ($name -and ($_.Property -contains 'SP')) { $sp = Get-ItemPropertyValue -Path $_.PSPath -Name SP }
            if ($_.Property -contains 'Install') { $install = Get-ItemPropertyValue -Path $_.PSPath -Name Install }
            if (-not $install) {
                Write-Host -Object "  $($parentName)  $($name)"
            }
            elseif ($install -eq '1') {
                if (-not $sp) {
                    Write-Host -Object "  $($_.PSChildName)  $($name)"
                }
                else {
                    Write-Host -Object "  $($_.PSChildName)  $($name) SP$($sp)"
                }
            }
        }
    }
}