function Test-IsLocalComputer {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    if (-not $CimSession) {

        return $true

    }

    $TargetName = $CimSession.ComputerName

    if ($TargetName -ieq $env:COMPUTERNAME) {

        return $true

    }

    if ($TargetName -ieq "localhost") {

        return $true

    }

    if ($TargetName -eq "127.0.0.1") {

        return $true

    }

    if ($TargetName -eq "::1") {

        return $true

    }

    return $false

}

function Get-TargetComputerName {

    <#
    .SYNOPSIS
        Returns the target computer name.

    .PARAMETER CimSession
        Optional CIM Session.

    .OUTPUTS
        String
    #>

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    if (-not $CimSession) {

        return $env:COMPUTERNAME

    }

    if ([string]::IsNullOrWhiteSpace($CimSession.ComputerName)) {

        return $env:COMPUTERNAME

    }

    return $CimSession.ComputerName

}

function Get-CimData {

    <#
    .SYNOPSIS
        Retrieves CIM information locally or remotely.

    .PARAMETER ClassName

    .PARAMETER Filter

    .PARAMETER CimSession
    #>

    param(

        [Parameter(Mandatory)]
        [string]$ClassName,

        [string]$Filter,

        [Microsoft.Management.Infrastructure.CimSession]$CimSession

    )

    $Parameters = @{

        ClassName = $ClassName

    }

    if ($Filter) {

        $Parameters.Filter = $Filter

    }

    if ($CimSession) {

        $Parameters.CimSession = $CimSession

    }

    Get-CimInstance @Parameters

}

function Invoke-Safely {

    <#
    .SYNOPSIS
        Executes a script block safely.

    .PARAMETER ScriptBlock
    #>

    param(

        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock

    )

    try {

        & $ScriptBlock

    }
    catch {

        return $null

    }

}
