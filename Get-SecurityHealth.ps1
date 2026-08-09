function Get-SecurityHealth {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )

    $ComputerName = Get-TargetComputerName -CimSession $CimSession

    if (Test-IsLocalComputer -CimSession $CimSession) {

        # Local

    }
    else {

        # Remoto

    }

}


$BitLocker = Invoke-Safely {

    (Get-BitLockerVolume -MountPoint "C:").ProtectionStatus

}

$BitLocker = Invoke-Command `
    -ComputerName $ComputerName {

    (Get-BitLockerVolume -MountPoint "C:").ProtectionStatus

}

$Defender = Invoke-Safely {

    (Get-MpComputerStatus).AntivirusEnabled

}

$Defender = Invoke-Command `
    -ComputerName $ComputerName {

    (Get-MpComputerStatus).AntivirusEnabled

}

$Firewall = Invoke-Safely {

    (Get-NetFirewallProfile |
        Where-Object Enabled).Count

}

$Firewall = Invoke-Command `
    -ComputerName $ComputerName {

    (Get-NetFirewallProfile |
        Where-Object Enabled).Count

}

$TPM = Invoke-Safely {

    (Get-Tpm).TpmPresent

}

$TPM = Invoke-Command `
    -ComputerName $ComputerName {

    (Get-Tpm).TpmPresent

}

$SecureBoot = Invoke-Safely {

    Confirm-SecureBootUEFI

}

$SecureBoot = Invoke-Command `
    -ComputerName $ComputerName {

    Confirm-SecureBootUEFI

}

$Health = "Healthy"

if (-not $Defender) {

    $Health = "Critical"

}

if ($Firewall -eq 0) {

    $Health = "Critical"

}

[PSCustomObject]@{

    ComputerName = $ComputerName

    ScanDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    BitLocker = $BitLocker

    Defender = $Defender

    FirewallProfilesEnabled = $Firewall

    TPM = $TPM

    SecureBoot = $SecureBoot

    Health = $Health

}
