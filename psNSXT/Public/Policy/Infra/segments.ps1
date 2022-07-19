#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-NSXTPolicyInfraSegments {

    <#
        .SYNOPSIS
        Add a Segment

        .DESCRIPTION
        Add a Segment (Vlan)

        .EXAMPLE
        Get-NSXTTransportZones -display_name MyTZ-Vlan | Add-NSXTPolicyInfraSegments -segment MySegment -vlan_ids 2

        Add a (vlan) Segment MySegment on MyTZ-Vlan with vlan id 2

        .EXAMPLE
        Get-NSXTTransportZones -display_name MyTZ-Vlan | Add-NSXTPolicyInfraSegments -segment MySegment -vlan_ids 2,44 -display_name MySegment2and44

        Add a (vlan) Segment with (display_)name MySegment2and44 on MyTZ-Vlan with vlan id 2 and 44

    #>

    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { Confirm-NSXTTransportZones $_ })]
        [psobject]$tz,
        [Parameter(Mandatory = $true)]
        [string]$segment,
        [Parameter(Mandatory = $false)]
        [string]$display_name,
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 4096)]
        [int[]]$vlan_ids,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'policy/api/v1/infra/segments'
        $uri += "/" + $segment
        $transport_zone_path = "/infra/sites/default/enforcement-points/default/transport-zones/" + $tz.id

        $_sg = new-Object -TypeName PSObject

        $_sg | add-member -name "type" -membertype NoteProperty -Value "DISCONNECTED"

        $_sg | add-member -name "transport_zone_path" -membertype NoteProperty -Value $transport_zone_path

        if ( $PsBoundParameters.ContainsKey('display_name') ) {
            $_sg | add-member -name "display_name" -membertype NoteProperty -Value $display_name
        }

        $_sg | add-member -name "vlan_ids" -membertype NoteProperty -Value @($vlan_ids)

        $response = Invoke-NSXTRestMethod -uri $uri -method 'PATCH' -body $_sg -connection $connection
        $response

        Get-NSXTPolicyInfraSegments -segment $segment -connection $connection
    }

    End {
    }
}

function Add-NSXTPolicyInfraSegmentsOverlay {

    <#
        .SYNOPSIS
        Add a Segment

        .DESCRIPTION
        Add a Segment (Overlay)

        .EXAMPLE
        Get-NSXTTransportZones -display_name MyTZ-Overlay | Add-NSXTPolicyInfraSegmentsOverlay -segment MySegment -gateway_address 192.0.2.254/24 -tier1 MyT1

        Add a (Overlay) Segment MySegment on MyTZ-Overlay with Gateway 192.0.2.254 on Tier MyT1

        .EXAMPLE
        Get-NSXTTransportZones -display_name TZ-OVERLAY | Add-NSXTPolicyInfraSegmentsOverlay -segment MySegment -gateway_address 192.0.2.254/24 -tier1 MyT1 -dhcp_config MyDHCPConfig -dhcp_ranges 192.0.2.1-192.0.2.100 -dhcp_server 192.0.2.253/24

        Add a (Overlay) Segment MySegment with DHCP Config MyDHCPConfig and DHCP Range 192.0.2.1-192.0.2.100 and DHCP Server 192.0.2.250

        .EXAMPLE
        Get-NSXTTransportZones -display_name TZ-OVERLAY | Add-NSXTPolicyInfraSegmentsOverlay -segment MySegment -gateway_address 192.0.2.254/24 -tier1 MyT1 -dhcp_config MyDHCPConfig -dhcp_ranges 192.0.2.1-192.0.2.100 -dhcp_server 192.0.2.253/24 -dhcp_leases 3600 -dhcp_dns 192.51.100.1, 192.51.100.2 -dhcp_ntp 203.0.113.1, 203.0.113.2

        Add a (Overlay) Segment MySegment with DHCP Leases : 3600 (seconds) and DHCP DNS Server 192.51.100.1, 192.51.100.2 and DHCP NTP (Option 42) Server 203.0.113.1, 203.0.113.2
    #>

    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { Confirm-NSXTTransportZones $_ })]
        [psobject]$tz,
        [Parameter(Mandatory = $true)]
        [string]$segment,
        [Parameter(Mandatory = $true)]
        [string]$tier1,
        [Parameter(Mandatory = $false)]
        [string]$display_name,
        [Parameter(Mandatory = $true)]
        [string]$gateway_address,
        [Parameter(Mandatory = $true, ParameterSetName = "dhcp")]
        [string]$dhcp_config,
        [Parameter(Mandatory = $true, ParameterSetName = "dhcp")]
        [string[]]$dhcp_ranges,
        [Parameter(Mandatory = $true, ParameterSetName = "dhcp")]
        [string]$dhcp_server,
        [Parameter(Mandatory = $false, ParameterSetName = "dhcp")]
        [int]$dhcp_leases,
        [Parameter(Mandatory = $false, ParameterSetName = "dhcp")]
        [string[]]$dhcp_dns,
        [Parameter(Mandatory = $false, ParameterSetName = "dhcp")]
        [string[]]$dhcp_ntp,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'policy/api/v1/infra/segments'
        $uri += "/" + $segment
        $transport_zone_path = "/infra/sites/default/enforcement-points/default/transport-zones/" + $tz.id
        $connectivity_path = "/infra/tier-1s/" + $tier1

        $_sg = new-Object -TypeName PSObject

        $_sg | add-member -name "type" -membertype NoteProperty -Value "ROUTED"

        $_sg | add-member -name "transport_zone_path" -membertype NoteProperty -Value $transport_zone_path

        $_sg | add-member -name "connectivity_path" -membertype NoteProperty -Value $connectivity_path

        if ( $PsBoundParameters.ContainsKey('display_name') ) {
            $_sg | add-member -name "display_name" -membertype NoteProperty -Value $display_name
        }

        $_subnets = new-Object -TypeName PSObject
        $_subnets | add-member -name "gateway_address" -membertype NoteProperty -Value $gateway_address

        if ( $PSCmdlet.ParameterSetName -eq "dhcp" ) {
            $dhcp_config_path = "/infra/dhcp-server-configs/" + $dhcp_config

            $_sg | add-member -name "dhcp_config_path" -membertype NoteProperty -Value $dhcp_config_path

            $_subnets | add-member -name "dhcp_ranges" -membertype NoteProperty -Value @($dhcp_ranges)

            $_dhcp_config = new-Object -TypeName PSObject

            $_dhcp_config | add-member -name "resource_type" -membertype NoteProperty -Value "SegmentDhcpV4Config"

            $_dhcp_config | add-member -name "server_address" -membertype NoteProperty -Value $dhcp_server

            if ( $PsBoundParameters.ContainsKey('dhcp_leases') ) {
                $_dhcp_config | add-member -name "lease_time" -membertype NoteProperty -Value $dhcp_leases
            }

            if ( $PsBoundParameters.ContainsKey('dhcp_dns') ) {
                $_dhcp_config | add-member -name "dns_servers" -membertype NoteProperty -Value @($dhcp_dns)
            }

            #Options..

            if ( $PsBoundParameters.ContainsKey('dhcp_ntp') ) {

                $_dhcp_options = new-Object -TypeName PSObject

                $_dhcp_others = new-Object -TypeName PSObject

                #Only Support NTP...
                $_dhcp_others | add-member -name "code" -membertype NoteProperty -Value "42"

                $_dhcp_others | add-member -name "values" -membertype NoteProperty -Value @($dhcp_ntp)

                $_dhcp_options | add-member -name "others" -membertype NoteProperty -Value @($_dhcp_others)

                $_dhcp_config | add-member -name "options" -membertype NoteProperty -Value $_dhcp_options
            }

            $_subnets | add-member -name "dhcp_config" -membertype NoteProperty -Value $_dhcp_config

        }
        $_sg | add-member -name "subnets" -membertype NoteProperty -Value @($_subnets)

        $response = Invoke-NSXTRestMethod -uri $uri -method 'PATCH' -body $_sg -connection $connection
        $response

        Get-NSXTPolicyInfraSegments -segment $segment -connection $connection
    }

    End {
    }
}
function Get-NSXTPolicyInfraSegments {

    <#
        .SYNOPSIS
        Get information about Segments

        .DESCRIPTION
        Returns information about Segments

        .EXAMPLE
        Get-NSXTPolicyInfraSegments

        Display all Transport Zones

        .EXAMPLE
        Get-NSXTPolicyInfraSegments -segment mySegment

        Display Segments with segment mySegment

        .EXAMPLE
        Get-NSXTPolicyInfraSegments -display_name mySegment

        Display Segments with (display) name mySegment

    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = "segment")]
        [string]$segment,
        [Parameter(Mandatory = $false, ParameterSetName = "display_name")]
        [string]$display_name,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'policy/api/v1/infra/segments'

        if ( $PsBoundParameters.ContainsKey('segment') ) {
            $uri += "/$segment"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection

        switch ( $PSCmdlet.ParameterSetName ) {
            "segment" {
                #When there is a zone_id, it is directly the result...
                $response
            }
            "display_name" {
                #When there is a display_name, search on response
                $response.results | Where-Object { $_.display_name -eq $display_name }
            }
            default {
                $response.results
            }
        }

    }

    End {
    }
}

function Set-NSXTPolicyInfraSegments {

    <#
        .SYNOPSIS
        Configure a Segment

        .DESCRIPTION
        Configure a Segment (Vlan)

        .EXAMPLE
        Get-NSXTPolicyInfraSegments -display_name MySegment | Set-NSXTPolicyInfraSegments -vlan_ids 23

        Configure a (vlan) Segment MySegment with vlan id 23

        .EXAMPLE
        Get-NSXTPolicyInfraSegments -display_name MySegment | Set-NSXTPolicyInfraSegments -vlan_ids 23,44

        Configure a (vlan) Segment MySegment with vlan id 23 and 44

        .EXAMPLE
        Get-NSXTPolicyInfraSegments -display_name MySegment | Set-NSXTPolicyInfraSegments -display_name MySegment2

        Configure a (vlan) Segment MySegment with (display_)name MySegment2


    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { Confirm-NSXTSegments $_ })]
        [psobject]$segment,
        [Parameter(Mandatory = $false)]
        [string]$display_name,
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 4096)]
        [int[]]$vlan_ids,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'policy/api/v1/infra/segments'
        $uri += "/" + $segment.id
        $segment_name = $segment.display_name


        if ( $PsBoundParameters.ContainsKey('display_name') ) {
            $segment.display_name = $display_name
        }

        if ( $PsBoundParameters.ContainsKey('vlan_ids') ) {
            $segment.vlan_ids = @($vlan_ids)
        }

        if ($PSCmdlet.ShouldProcess("$segment_name", 'Configure Segment')) {
            $response = Invoke-NSXTRestMethod -uri $uri -method 'PUT' -body $segment -connection $connection
            $response.results
        }

        Get-NSXTPolicyInfraSegments -segment $segment.id -connection $connection
    }

    End {
    }
}

function Remove-NSXTPolicyInfraSegments {

    <#
        .SYNOPSIS
        Remove a Segment

        .DESCRIPTION
        Remove a Segment

        .EXAMPLE
        $sg = Get-NSXTPolicyInfraSegments -display_name MySegment
        PS C:\>$sg | Remove-NSXTPolicyInfraSegments

        Remove Segment e with ff8140b0-010e-4e92-aa62-a55766f17da0

        .EXAMPLE
        Remove-NSXTPolicyInfraSegments -segment MySegment -confirm:$false

        Remove Segment MySegment with no confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ParameterSetName = "segment")]
        [string]$segment,
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1, ParameterSetName = "sg")]
        [ValidateScript( { Confirm-NSXTSegments $_ })]
        [psobject]$sg,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        #get segment name froms segment object
        if ($sg) {
            $segment = $sg.id
            $name = " (" + $sg.display_name + ")"
        }

        $uri = "policy/api/v1/infra/segments/$segment"

        if ($PSCmdlet.ShouldProcess("${segment}${name}", "Remove Segment")) {
            Write-Progress -activity "Remove Segment"
            Invoke-NSXTRestMethod -method "DELETE" -uri $uri -connection $connection
            Write-Progress -activity "Remove Segment" -completed
        }
    }

    End {
    }
}