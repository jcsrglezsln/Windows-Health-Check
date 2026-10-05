param(
    [ValidateNotNullOrEmpty()]
    [string]$ComputerName
)


# ==========================
# LOAD MODULES
# ==========================

. "$PSScriptRoot\Common.ps1"
. "$PSScriptRoot\Get-DiskHealth.ps1"
. "$PSScriptRoot\Get-MemoryHealth.ps1"
. "$PSScriptRoot\Get-ServiceHealth.ps1"
. "$PSScriptRoot\Get-SecurityHealth.ps1"
. "$PSScriptRoot\Get-SystemHealth.ps1"


# ==========================
# CIM SESSION
# ==========================

$CimSession = $null

try {

    if ($ComputerName) {

        $CimSession = New-CimSession `
            -ComputerName $ComputerName `
            -ErrorAction Stop

    }


    # ==========================
    # SYSTEM HEALTH
    # ==========================

    Get-SystemHealth -CimSession $CimSession

}
catch {

    Write-Error "Unable to perform health check: $($_.Exception.Message)"

}
finally {

    if ($CimSession) {

        Remove-CimSession $CimSession

    }

}
