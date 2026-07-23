function Get-DiskHealth {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    if ($CimSession) {

        $Disk = Get-CimInstance `
            Win32_LogicalDisk `
            -Filter "DriveType=3" `
            -CimSession $CimSession

    }
    else {

        $Disk = Get-CimInstance `
            Win32_LogicalDisk `
            -Filter "DriveType=3"

    }

    $ComputerName = if ($CimSession) {
    $CimSession.ComputerName
    }
    else {
        $env:COMPUTERNAME
    }

    foreach ($Drive in $Disk) {

      $SizeGB = [math]::Round($Drive.Size / 1GB, 2)
      
      $FreeGB = [math]::Round($Drive.FreeSpace / 1GB, 2)
  
      $UsedGB = [math]::Round($SizeGB - $FreeGB, 2)
  
      $FreePercent = [math]::Round(($Drive.FreeSpace / $Drive.Size) * 100, 2)

      if ($Drive.Size -gt 0) {

          $FreePercent = [math]::Round(($Drive.FreeSpace / $Drive.Size) * 100, 2)
      
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
    
        ScanDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
        DriveLetter = $Drive.DeviceID
    
        VolumeName = $Drive.VolumeName
    
        FileSystem = $Drive.FileSystem
    
        SizeGB = $SizeGB
    
        FreeGB = $FreeGB
    
        UsedGB = $UsedGB
    
        FreePercent = $FreePercent
    
        Health = $Health
    
      }

    }

}
