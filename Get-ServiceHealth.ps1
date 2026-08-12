function Get-ServiceHealth {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )


    $ServicesToCheck = @(
        "wuauserv",
        "WinDefend",
        "mpssvc",
        "WinRM",
        "BITS"
    )


    # ==========================
    # BUILD WMI FILTER
    # ==========================

    $Filter = ($ServicesToCheck | ForEach-Object {

        "Name='$_'"

    }) -join " OR "


    # ==========================
    # GET SERVICES
    # ==========================

    if ($CimSession) {

        $Services = Get-CimInstance `
            Win32_Service `
            -Filter $Filter `
            -CimSession $CimSession

        $ComputerName = $CimSession.ComputerName

    }
    else {

        $Services = Get-CimInstance `
            Win32_Service `
            -Filter $Filter

        $ComputerName = $env:COMPUTERNAME

    }


    # ==========================
    # EVALUATE SERVICES
    # ==========================

    foreach ($Service in $Services) {


        if ($Service.State -eq "Running") {

            $Health = "Healthy"

        }
        elseif (
            $Service.State -eq "Stopped" -and
            $Service.StartMode -eq "Auto"
        ) {

            $Health = "Critical"

        }
        elseif (
            $Service.State -eq "Stopped" -and
            $Service.StartMode -eq "Manual"
        ) {

            $Health = "Healthy"

        }
        elseif (
            $Service.State -eq "Stopped" -and
            $Service.StartMode -eq "Disabled"
        ) {

            $Health = "Healthy"

        }
        else {

            $Health = "Warning"

        }


        # ==========================
        # RESULT
        # ==========================

        [PSCustomObject]@{

            ComputerName = $ComputerName

            ScanDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            ServiceName = $Service.Name

            DisplayName = $Service.DisplayName

            State = $Service.State

            StartMode = $Service.StartMode

            ProcessId = $Service.ProcessId

            Health = $Health

        }

    }

}
