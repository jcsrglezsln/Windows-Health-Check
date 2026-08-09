. "$PSScriptRoot\Common.ps1"


function Get-SecurityHealth {

    param(
        [Microsoft.Management.Infrastructure.CimSession]$CimSession
    )


    $ComputerName = Get-TargetComputerName -CimSession $CimSession


    if (Test-IsLocalComputer -CimSession $CimSession) {

        # ==========================
        # LOCAL
        # ==========================

        $BitLocker = Invoke-Safely {

            (Get-BitLockerVolume -MountPoint "C:").ProtectionStatus

        }


        $Defender = Invoke-Safely {

            (Get-MpComputerStatus).AntivirusEnabled

        }


        $Firewall = Invoke-Safely {

            (Get-NetFirewallProfile |
                Where-Object Enabled).Count

        }


        $TPMInfo = Invoke-Safely {

            Get-Tpm

        }


        $SecureBoot = Invoke-Safely {

            Confirm-SecureBootUEFI

        }

    }
    else {

        # ==========================
        # REMOTE
        # ==========================

        $BitLocker = Invoke-Command `
            -ComputerName $ComputerName {

            try {

                (Get-BitLockerVolume `
                    -MountPoint "C:").ProtectionStatus

            }
            catch {

                $null

            }

        }


        $Defender = Invoke-Command `
            -ComputerName $ComputerName {

            try {

                (Get-MpComputerStatus).AntivirusEnabled

            }
            catch {

                $null

            }

        }


        $Firewall = Invoke-Command `
            -ComputerName $ComputerName {

            try {

                (Get-NetFirewallProfile |
                    Where-Object Enabled).Count

            }
            catch {

                $null

            }

        }


        $TPMInfo = Invoke-Command `
            -ComputerName $ComputerName {

            try {

                Get-Tpm

            }
            catch {

                $null

            }

        }


        $SecureBoot = Invoke-Command `
            -ComputerName $ComputerName {

            try {

                Confirm-SecureBootUEFI

            }
            catch {

                $null

            }

        }

    }


    # ==========================
    # TPM INFORMATION
    # ==========================

    $TPM = $TPMInfo.TpmPresent

    $TPMReady = $TPMInfo.TpmReady

    $TPMRestartPending = $TPMInfo.RestartPending


    # ==========================
    # HEALTH EVALUATION
    # ==========================

    $Health = "Healthy"


    if (-not $Defender) {

        $Health = "Critical"

    }
    elseif ($Firewall -eq 0) {

        $Health = "Critical"

    }
    elseif ($BitLocker -eq "Off") {

        $Health = "Warning"

    }
    elseif (-not $TPM) {

        $Health = "Warning"

    }
    elseif (-not $SecureBoot) {

        $Health = "Warning"

    }


    # ==========================
    # RESULT
    # ==========================

    [PSCustomObject]@{

        ComputerName = $ComputerName

        ScanDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        BitLocker = $BitLocker

        Defender = $Defender

        FirewallProfilesEnabled = $Firewall

        TPM = $TPM

        TPMReady = $TPMReady

        TPMRestartPending = $TPMRestartPending

        SecureBoot = $SecureBoot

        Health = $Health

    }

}
