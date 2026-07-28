function Get-MemoryHealth {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    if ($CimSession) {

        $OS = Get-CimInstance `
            Win32_OperatingSystem `
            -CimSession $CimSession

    }
    else {

        $OS = Get-CimInstance `
            Win32_OperatingSystem

    }

    $ComputerName = if ($CimSession) {
        $CimSession.ComputerName
    }
    else {
        $env:COMPUTERNAME
    }

    $TotalRAM = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)

    $FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)

    $UsedRAM = [math]::Round($TotalRAM - $FreeRAM, 2)

    if ($TotalRAM -gt 0) {

        $MemoryUsage = [math]::Round(($UsedRAM / $TotalRAM) * 100, 2)

    }
    else {

        $MemoryUsage = 0

    }

    if ($MemoryUsage -gt 90) {

        $Health = "Critical"

    }
    elseif ($MemoryUsage -ge 80) {

        $Health = "Warning"

    }
    else {

        $Health = "Healthy"

    }

    [PSCustomObject]@{

        ComputerName = $ComputerName

        ScanDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        TotalRAM_GB = $TotalRAM

        UsedRAM_GB = $UsedRAM

        FreeRAM_GB = $FreeRAM

        MemoryUsagePercent = $MemoryUsage

        Health = $Health

    }

}
