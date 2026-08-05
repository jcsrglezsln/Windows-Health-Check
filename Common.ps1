function Test-IsLocalComputer {

    <#
    .SYNOPSIS
        Determines whether the target computer is the local machine.

    .DESCRIPTION
        Returns True when no CimSession is provided or when the
        CimSession points to the local computer.

    .PARAMETER CimSession
        Optional CIM Session.

    .OUTPUTS
        Boolean
    #>

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    if (-not $CimSession) {

        return $true

    }

    $Names = @(
        $env:COMPUTERNAME.ToUpper()
        "LOCALHOST"
        "127.0.0.1"
    )

    if ($Names -contains $CimSession.ComputerName.ToUpper()) {

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

    if (Test-IsLocalComputer $CimSession) {

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
