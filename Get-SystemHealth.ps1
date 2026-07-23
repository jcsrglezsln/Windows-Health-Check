function Get-SystemHealth {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    if ($CimSession) {

        $Computer = Get-CimInstance `
            Win32_ComputerSystem `
            -CimSession $CimSession

        $OS = Get-CimInstance `
            Win32_OperatingSystem `
            -CimSession $CimSession

    }
    else {

        $Computer = Get-CimInstance `
            Win32_ComputerSystem

        $OS = Get-CimInstance `
            Win32_OperatingSystem

    }

    $LastBoot = $OS.LastBootUpTime

    $Uptime = (New-TimeSpan `
        -Start $LastBoot `
        -End (Get-Date)).Days

    [PSCustomObject]@{

        ComputerName = $Computer.Name

        Manufacturer = $Computer.Manufacturer

        Model = $Computer.Model

        OperatingSystem = $OS.Caption

        Version = $OS.Version

        Build = $OS.BuildNumber

        LastBoot = $LastBoot

        UptimeDays = $Uptime

    }

}
