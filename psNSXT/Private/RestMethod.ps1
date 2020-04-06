#
# Copyright 2018, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Invoke-NSXTRestMethod {

    <#
      .SYNOPSIS
      Invoke RestMethod with NSX-T connection (internal) variable

      .DESCRIPTION
      Invoke RestMethod with NSX-T connection variable (token,.)

      .EXAMPLE
      Invoke-NSXTRestMethod -method "get" -uri "api/v1/cluster/status"

      Invoke-RestMethod with NSX-T connection for get api/v1/cluster/status uri
    #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$uri,
        [Parameter(Mandatory = $false)]
        [ValidateSet("GET", "PUT", "PATCH", "POST", "DELETE")]
        [String]$method = "GET",
        [Parameter(Mandatory = $false)]
        [psobject]$body,
        [Parameter(Mandatory = $false)]
        [psobject]$connection
    )

    Begin {
    }

    Process {

        if ($null -eq $connection ) {
            if ($null -eq $DefaultNSXTConnection) {
                Throw "Not Connected. Connect to the NSX-T with Connect-NSXT"
            }
            $connection = $DefaultNSXTConnection
        }

        $Server = $connection.Server
        $port = $connection.port
        $headers = $connection.headers
        $invokeParams = $connection.invokeParams

        $fullurl = "https://${Server}:${port}/${uri}"

        #Extra parameter...
        if ($fullurl -NotMatch "\?") {
            $fullurl += "?"
        }

        try {
            if ($body) {

                Write-Verbose ($body | ConvertTo-Json)

                $response = Invoke-RestMethod $fullurl -Method $method -body ($body | ConvertTo-Json) -Headers $headers @invokeParams
            }
            else {
                $response = Invoke-RestMethod $fullurl -Method $method -Headers $headers @invokeParams
            }
        }

        catch {
            Show-NSXTException $_
            throw "Unable to use NSX-T API"
        }
        $response

    }

}