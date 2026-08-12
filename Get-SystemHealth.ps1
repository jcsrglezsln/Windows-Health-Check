function Get-SystemHealth {

    <#
    .SYNOPSIS
        Performs a complete Windows system health assessment.

    .DESCRIPTION
        Collects disk, memory, service and security health information
        from a local or remote Windows computer.

    .PARAMETER CimSession
        Optional CIM session used to query a remote computer.

    .OUTPUTS
        PSCustomObject
    #>

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )


    # ==========================
    # COMPUTER NAME
    # ==========================

    $ComputerName = Get-TargetComputerName -CimSession $CimSession


    # ==========================
    # HEALTH MODULES
    # ==========================

    $DiskHealth = Get-DiskHealth `
        -CimSession $CimSession

    $MemoryHealth = Get-MemoryHealth `
        -CimSession $CimSession

    $ServiceHealth = Get-ServiceHealth `
        -CimSession $CimSession

    $SecurityHealth = Get-SecurityHealth `
        -CimSession $CimSession


    # ==========================
    # DISK HEALTH
    # ==========================

    if ($DiskHealth.Health -contains "Critical") {

        $DiskStatus = "Critical"

    }
    elseif ($DiskHealth.Health -contains "Warning") {

        $DiskStatus = "Warning"

    }
    else {

        $DiskStatus = "Healthy"

    }


    # ==========================
    # SERVICE HEALTH
    # ==========================

    if ($ServiceHealth.Health -contains "Critical") {

        $ServiceStatus = "Critical"

    }
    elseif ($ServiceHealth.Health -contains "Warning") {

        $ServiceStatus = "Warning"

    }
    else {

        $ServiceStatus = "Healthy"

    }


    # ==========================
    # MEMORY HEALTH
    # ==========================

    $MemoryStatus = $MemoryHealth.Health


    # ==========================
    # SECURITY HEALTH
    # ==========================

    $SecurityStatus = $SecurityHealth.Health


    # ==========================
    # OVERALL HEALTH
    # ==========================

    $HealthStates = @(
        $DiskStatus
        $MemoryStatus
        $ServiceStatus
        $SecurityStatus
    )


    if ($HealthStates -contains "Critical") {

        $OverallHealth = "Critical"

    }
    elseif ($HealthStates -contains "Warning") {

        $OverallHealth = "Warning"

    }
    else {

        $OverallHealth = "Healthy"

    }


    # ==========================
    # RESULT
    # ==========================

    [PSCustomObject]@{

        ComputerName   = $ComputerName

        ScanDate       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        OverallHealth  = $OverallHealth

        DiskHealth     = $DiskStatus

        MemoryHealth   = $MemoryStatus

        ServiceHealth  = $ServiceStatus

        SecurityHealth = $SecurityStatus

    }

}
