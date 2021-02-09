#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Connect-NSXT {

    <#
      .SYNOPSIS
      Connect to a NSX-T

      .DESCRIPTION
      Connect to a NSX-T

      .EXAMPLE
      Connect-NSXT -Server 192.0.2.1

      Connect to a NSX-T with IP 192.0.2.1

      .EXAMPLE
      Connect-NSXT -Server 192.0.2.1 -SkipCertificateCheck

      Connect to a NSX-T with IP 192.0.2.1 and disable Certificate (chain) check

      .EXAMPLE
      Connect-NSX-T -Server 192.0.2.1 -port 4443

      Connect to a NSX-T using HTTPS (with port 4443) with IP 192.0.2.1 using (Get-)credential

      .EXAMPLE
      $cred = get-credential
      Connect-NSXT -Server 192.0.2.1 -credential $cred

      Connect to a NSX-T with IP 192.0.2.1 and passing (Get-)credential

      .EXAMPLE
      $mysecpassword = ConvertTo-SecureString mypassword -AsPlainText -Force
      Connect-NSXT -Server 192.0.2.1 -Username admin -Password $mysecpassword

      Connect to a NSX-T with IP 192.0.2.1 using Username and Password

      .EXAMPLE
      $nsxt1 = Connect-NSXT -Server 192.0.2.1
      Connect to an NSX-T with IP 192.0.2.1 and store connection info to $nsxt1 variable

      .EXAMPLE
      $nsxt2 = Connect-NSXT -Server 192.0.2.1 -DefaultConnection:$false

      Connect to an NSX-T with IP 192.0.2.1 and store connection info to $nsxt2 variable
      and don't store connection on global ($DefaultNSXTConnection) variable
  #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$Server,
        [Parameter(Mandatory = $false)]
        [String]$Username,
        [Parameter(Mandatory = $false)]
        [SecureString]$Password,
        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential,
        [switch]$SkipCertificateCheck = $false,
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 65535)]
        [int]$port = 443,
        [Parameter(Mandatory = $false)]
        [boolean]$DefaultConnection = $true
    )

    Begin {
    }

    Process {

        $connection = @{server = ""; port = ""; headers = ""; invokeParams = "" }

        #If there is a password (and a user), create a credential
        if ($Password) {
            $Credential = New-Object System.Management.Automation.PSCredential($Username, $Password)
        }
        #Not Credential (and no password)
        if ($null -eq $Credential) {
            $Credential = Get-Credential -Message 'Please enter administrative credential for your NSX-T'
        }

        $cred = $Credential.username + ":" + $Credential.GetNetworkCredential().Password
        $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($cred))
        #if username is admin or audit, it is Basic
        if ($Credential.username -eq "admin" -or $Credential.username -eq "audit" ) {
            $auth = "Basic "
        }
        # else (vIDM or LDAP), it is Remote...
        else {
            $auth = "Remote "
        }
        $headers = @{ Authorization = $auth + $base64; Accept = "application/json"; "Content-type" = "application/json" }
        $invokeParams = @{DisableKeepAlive = $false; UseBasicParsing = $true; SkipCertificateCheck = $SkipCertificateCheck }


        if ("Desktop" -eq $PSVersionTable.PsEdition) {
            #Remove -SkipCertificateCheck from Invoke Parameter (not supported <= PS 5)
            $invokeParams.remove("SkipCertificateCheck")
        }
        else {
            #Core Edition
            #Remove -UseBasicParsing (Enable by default with PowerShell 6/Core)
            $invokeParams.remove("UseBasicParsing")
        }

        #for PowerShell (<=) 5 (Desktop), Enable TLS 1.1, 1.2 and Disable SSL chain trust (needed/recommended by VMware NSX-T)
        if ("Desktop" -eq $PSVersionTable.PsEdition) {
            #Enable TLS 1.1 and 1.2
            Set-NSXTCipherSSL
            if ($SkipCertificateCheck) {
                #Disable SSL chain trust...
                Set-NSXTuntrustedSSL
            }
        }

        $connection.server = $server
        $connection.headers = $headers
        $connection.port = $port
        $connection.invokeParams = $invokeParams

        if ( $DefaultConnection ) {
            set-variable -name DefaultNSXTConnection -value $connection -scope Global
        }

        $connection
    }

    End {
    }
}

function Disconnect-NSXT {

    <#
        .SYNOPSIS
        Disconnect to a NSX-T

        .DESCRIPTION
        Disconnect the connection on NSX-T

        .EXAMPLE
        Disconnect-NSXT

        Disconnect the connection

        .EXAMPLE
        Disconnect-NSXT -confirm:$false

        Disconnect the connection with no confirmation

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSObject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        if ($PSCmdlet.ShouldProcess($connection.server, 'Proceed with removal of NSX-T connection ?')) {
            Write-Progress -activity "Remove NSX-T connection"
            if (Test-Path variable:global:DefaultNSXTConnection) {
                Remove-Variable -name DefaultNSXTConnection -scope global
            }
            write-progress -activity "Remove NSX-T connection" -completed
        }

    }

    End {
    }
}