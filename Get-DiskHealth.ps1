function Get-DiskHealth {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    $Disk = Get-CimData `
        -ClassName "Win32_LogicalDisk" `
        -Filter "DriveType=3" `
        -CimSession $CimSession

    $ComputerName = Get-TargetComputerName -CimSession $CimSession

    foreach ($Drive in $Disk) {

        $SizeGB = [math]::Round($Drive.Size / 1GB, 2)

        $FreeGB = [math]::Round($Drive.FreeSpace / 1GB, 2)

        $UsedGB = [math]::Round($SizeGB - $FreeGB, 2)

        if ($Drive.Size -gt 0) {

            $FreePercent = [math]::Round(
                ($Drive.FreeSpace / $Drive.Size) * 100,
                2
            )

        }
        else {

            $FreePercent = 0

        }

        if ($FreePercent -lt 10) {

            $Health = "Critical"

        }
        elseif ($FreePercent -lt 20) {

            $Health = "Warning"

        }
        else {

            $Health = "Healthy"

        }

        [PSCustomObject]@{

            ComputerName = $ComputerName
            ScanDate     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            DriveLetter  = $Drive.DeviceID
            VolumeName   = $Drive.VolumeName
            FileSystem   = $Drive.FileSystem

            Health       = $Health

            SizeGB       = $SizeGB
            UsedGB       = $UsedGB
            FreeGB       = $FreeGB
            FreePercent  = $FreePercent
        }
    }
}
