#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

Function Confirm-NSXTFabricVirtualMachines {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Fabric Virtual Machines element

    if ( -not ( $argument | get-member -name host_id -Membertype Properties)) {
        throw "Element specified does not contain a host_id property."
    }
    if ( -not ( $argument | get-member -name external_id -Membertype Properties)) {
        throw "Element specified does not contain an external_id property."
    }
    if ( -not ( $argument | get-member -name resource_type -Membertype Properties)) {
        throw "Element specified does not contain a resource_type property."
    }
    if ( -not ( $argument | get-member -name display_name -Membertype Properties)) {
        throw "Element specified does not contain a display_name property."
    }
    $true

}

Function Confirm-NSXTLogicalPorts {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a Logical Ports element

    if ( -not ( $argument | get-member -name logical_switch_id -Membertype Properties)) {
        throw "Element specified does not contain a logical_switch_id property."
    }
    if ( -not ( $argument | get-member -name attachment -Membertype Properties)) {
        throw "Element specified does not contain an attachment property."
    }
    if ( -not ( $argument | get-member -name switching_profile_ids -Membertype Properties)) {
        throw "Element specified does not contain a switching_profile_ids property."
    }
    if ( -not ( $argument | get-member -name admin_state -Membertype Properties)) {
        throw "Element specified does not contain an admin_state property."
    }
    if ( -not ( $argument | get-member -name id -Membertype Properties)) {
        throw "Element specified does not contain an id property."
    }
    if ( -not ( $argument | get-member -name display_name -Membertype Properties)) {
        throw "Element specified does not contain a display_name property."
    }
    $true

}


Function Confirm-NSXTLogicalSwitches {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a Logical Switches element

    if ( -not ( $argument | get-member -name switch_type -Membertype Properties)) {
        throw "Element specified does not contain a switch_type property."
    }
    if ( -not ( $argument | get-member -name transport_zone_id -Membertype Properties)) {
        throw "Element specified does not contain a transport_zone_id property."
    }
    if ( -not ( $argument | get-member -name switching_profile_ids -Membertype Properties)) {
        throw "Element specified does not contain a switching_profile_ids property."
    }
    if ( -not ( $argument | get-member -name resource_type -Membertype Properties)) {
        throw "Element specified does not contain a resource_type property."
    }
    if ( -not ( $argument | get-member -name id -Membertype Properties)) {
        throw "Element specified does not contain a id property."
    }
    if ( -not ( $argument | get-member -name display_name -Membertype Properties)) {
        throw "Element specified does not contain a display_name property."
    }
    $true

}

Function Confirm-NSXTSegments {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like a Segment element

    if ( -not ( $argument | get-member -name type -Membertype Properties)) {
        throw "Element specified does not contain a type property."
    }
    if ( -not ( $argument | get-member -name vlan_ids -Membertype Properties)) {
        throw "Element specified does not contain an vlan_ids property."
    }
    if ( -not ( $argument | get-member -name transport_zone_path -Membertype Properties)) {
        throw "Element specified does not contain a transport_zone_path property."
    }
    if ( -not ( $argument | get-member -name resource_type -Membertype Properties)) {
        throw "Element specified does not contain a resource_type property."
    }
    if ( -not ( $argument | get-member -name id -Membertype Properties)) {
        throw "Element specified does not contain a id property."
    }
    if ( -not ( $argument | get-member -name display_name -Membertype Properties)) {
        throw "Element specified does not contain a display_name property."
    }
    if ( -not ( $argument | get-member -name path -Membertype Properties)) {
        throw "Element specified does not contain a path property."
    }
    if ( -not ( $argument | get-member -name relative_path -Membertype Properties)) {
        throw "Element specified does not contain a relative_path property."
    }
    if ( -not ( $argument | get-member -name parent_path -Membertype Properties)) {
        throw "Element specified does not contain a parent_path property."
    }
    if ( -not ( $argument | get-member -name marked_for_delete -Membertype Properties)) {
        throw "Element specified does not contain a marked_for_delete property."
    }
    $true

}

Function Confirm-NSXTTransportZones {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Transport Zones element

    if ( -not ( $argument | get-member -name transport_type -Membertype Properties)) {
        throw "Element specified does not contain a transport_type property."
    }
    if ( -not ( $argument | get-member -name host_switch_name -Membertype Properties)) {
        throw "Element specified does not contain an host_switch_name property."
    }
    if ( -not ( $argument | get-member -name host_switch_id -Membertype Properties)) {
        throw "Element specified does not contain a host_switch_id property."
    }
    if ( -not ( $argument | get-member -name host_switch_mode -Membertype Properties)) {
        throw "Element specified does not contain a host_switch_mode property."
    }
    if ( -not ( $argument | get-member -name nested_nsx -Membertype Properties)) {
        throw "Element specified does not contain a nested_nsx property."
    }
    if ( -not ( $argument | get-member -name is_default -Membertype Properties)) {
        throw "Element specified does not contain a is_default property."
    }
    if ( -not ( $argument | get-member -name resource_type -Membertype Properties)) {
        throw "Element specified does not contain a resource_type property."
    }
    if ( -not ( $argument | get-member -name id -Membertype Properties)) {
        throw "Element specified does not contain a id property."
    }
    if ( -not ( $argument | get-member -name display_name -Membertype Properties)) {
        throw "Element specified does not contain a display_name property."
    }
    $true

}