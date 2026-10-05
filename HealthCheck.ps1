param(
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

        $CimSession = New-CimSession -ComputerName $ComputerName

    }


    # ==========================
    # SYSTEM HEALTH
    # ==========================

    Get-SystemHealth -CimSession $CimSession

}
finally {

    if ($CimSession) {

        Remove-CimSession $CimSession

    }

}
