# psNSXT

This is a Powershell module for configure a NSX-T (Manager).

<p align="center">
<img src="https://raw.githubusercontent.com/psNSXT/psNSXT/master/Medias/psNSXT.png" width="250" height="250" />
</p>

With this module (version 0.2.0) you can manage:

- [VIFS](#vifs) (Get)
- [Logical Switches](#logical-switches) (Get)
- [Manage Tags](#manage-tags-on-fabric-virtual-machines) on (Fabric) Virtual Machines (Get/Set)
- [Transport Nodes](#transport-nodes) (Get)
- [Transport Zones](#transport-zones) (Add/Get/Set/Remove)
- [Segments](#segments) (Add/Get/Set/Remove type VLAN)

There is some extra feature :

- [Invoke API](#invoke-API) using Invoke-NSXTRestMethod
- [Multi Connection](#multiConnection)

More functionality will be added later.

Tested with NSX-T (using 2.4.x, 2.5.x  and 3.0.x release) on Windows/Linux/macOS

# Usage

All resource management functions are available with the Powershell verbs GET, ADD, SET, REMOVE.
For example, you can manage Tag on (Fabric) Virtual Machines with the following commands:
- `Get-NSXTFabricVirtualMachines`
- `Add-NSXTFabricVirtualMachines`
- `Set-NSXTFabricVirtualMachines`

# Requirements

- Powershell 6 (Core) or 5 (If possible get the latest version)
- A NSX-T Manager

# Instructions
### Install the module

```powershell
# Automated installation (Powershell 5 and later):
    Install-Module psNSXT

# Import the module
    Import-Module psNSXT

# Get commands in the module
    Get-Command -Module psNSXT

# Get help
    Get-Help Invoke-NSXTRestMethod -Full
```

# Examples
### Connecting to the NSX-T Manager Switch

The first thing to do is to connect to a NSX-T Manager with the command `Connect-NSXT`:

```powershell
# Connect to the NSX-T Manager
    Connect-NSXT 192.0.2.1

#we get a prompt for credential
```

### Invoke API
for example to get NSX-T System Configuration

```powershell
# get NSX-T Cluster Nodes Status using API
    Invoke-NSXTRestMethod -method "get" -uri "api/v1/cluster/nodes/status").management_cluster


role_config               : @{api_listen_addr=; mgmt_plane_listen_addr=; mgmt_cluster_listen_addr=; mpa_msg_client_info=; type=ManagementClusterRoleConfig}
transport_nodes_connected : 0
node_status               : @{version=2.4.0.0.0.12456291; mgmt_cluster_status=}
node_status_properties    : {@{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[]; mem_cache=1084880; mem_total=16413616; mem_used=14850840; source=cached;
                            swap_total=0; swap_used=0; system_time=1564726677000; uptime=4980067000}, @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[];
                            mem_cache=1033760; mem_total=16413616; mem_used=14851108; source=cached; swap_total=0; swap_used=0; system_time=1564726692000; uptime=4980082000},
                            @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[]; mem_cache=1034184; mem_total=16413616; mem_used=14853176; source=cached;
                            swap_total=0; swap_used=0; system_time=1564726707000; uptime=4980097000}, @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[];
                            mem_cache=1034768; mem_total=16413616; mem_used=14847884; source=cached; swap_total=0; swap_used=0; system_time=1564726722000; uptime=4980112000}...}
node_interface_properties : {@{admin_status=UP; interface_id=eth0; link_status=UP; mtu=1500; interface_alias=System.Object[]; source=cached}, @{admin_status=UP; interface_id=lo;
                            link_status=UP; mtu=65536; interface_alias=System.Object[]; source=cached}}

role_config               : @{api_listen_addr=; mgmt_plane_listen_addr=; mgmt_cluster_listen_addr=; mpa_msg_client_info=; type=ManagementClusterRoleConfig}
transport_nodes_connected : 2
node_status               : @{version=2.4.0.0.0.12456291; mgmt_cluster_status=}
node_status_properties    : {@{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[]; mem_cache=1091016; mem_total=16413616; mem_used=14825204; source=cached;
                            swap_total=0; swap_used=0; system_time=1564726724000; uptime=4976964000}, @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[];
                            mem_cache=1091876; mem_total=16413616; mem_used=14825348; source=cached; swap_total=0; swap_used=0; system_time=1564726739000; uptime=4976979000},
                            @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[]; mem_cache=1066700; mem_total=16413616; mem_used=14827700; source=cached;
                            swap_total=0; swap_used=0; system_time=1564726754000; uptime=4976994000}, @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[];
                            mem_cache=1067060; mem_total=16413616; mem_used=14825552; source=cached; swap_total=0; swap_used=0; system_time=1564726769000; uptime=4977009000}...}
node_interface_properties : {@{admin_status=UP; interface_id=eth0; link_status=UP; mtu=1500; interface_alias=System.Object[]; source=cached}, @{admin_status=UP; interface_id=lo;
                            link_status=UP; mtu=65536; interface_alias=System.Object[]; source=cached}}

role_config               : @{api_listen_addr=; mgmt_plane_listen_addr=; mgmt_cluster_listen_addr=; mpa_msg_client_info=; type=ManagementClusterRoleConfig}
transport_nodes_connected : 2
node_status               : @{version=2.4.0.0.0.12456291; mgmt_cluster_status=}
node_status_properties    : {@{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[]; mem_cache=1033840; mem_total=16413616; mem_used=14965048; source=cached;
                            swap_total=0; swap_used=0; system_time=1564726720000; uptime=4980854000}, @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[];
                            mem_cache=1040588; mem_total=16413616; mem_used=15008812; source=cached; swap_total=0; swap_used=0; system_time=1564726735000; uptime=4980869000},
                            @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[]; mem_cache=999100; mem_total=16413616; mem_used=14973768; source=cached;
                            swap_total=0; swap_used=0; system_time=1564726750000; uptime=4980884000}, @{cpu_cores=4; file_systems=System.Object[]; load_average=System.Object[];
                            mem_cache=999688; mem_total=16413616; mem_used=14966280; source=cached; swap_total=0; swap_used=0; system_time=1564726765000; uptime=4980899000}...}
node_interface_properties : {@{admin_status=UP; interface_id=eth0; link_status=UP; mtu=1500; interface_alias=System.Object[]; source=cached}, @{admin_status=UP; interface_id=lo;
                            link_status=UP; mtu=65536; interface_alias=System.Object[]; source=cached}}


# get NSX-T Capacity Usage using API

(Invoke-NSXTRestMethod -method "get" -uri "api/v1/capacity/usage").capacity_usage


usage_type               : NUMBER_OF_VCENTER_CLUSTERS
display_name             : Number of vCenter clusters
current_usage_count      : 3
max_supported_count      : 640
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 0,47
severity                 : INFO

usage_type               : NUMBER_OF_PREPARED_HOSTS
display_name             : Hypervisor Hosts
current_usage_count      : 4
max_supported_count      : 1024
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 0,39
severity                 : INFO

usage_type               : NUMBER_OF_SYSTEM_WIDE_VIFS
display_name             : System Wide Virtual Interfaces
current_usage_count      : 2
max_supported_count      : 20000
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 0,01
severity                 : INFO

usage_type               : NUMBER_OF_DFW_SECTIONS
display_name             : Firewall Sections
current_usage_count      : 2
max_supported_count      : 10000
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 0,02
severity                 : INFO

usage_type               : NUMBER_OF_DFW_RULES
display_name             : System Wide Firewall Rules
current_usage_count      : 2
max_supported_count      : 100000
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 0
severity                 : INFO

usage_type               : NUMBER_OF_NSGROUP
display_name             : Network and Security Groups
current_usage_count      : 1
max_supported_count      : 10000
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 0,01
severity                 : INFO

usage_type               : NUMBER_OF_MANAGERS
display_name             : Managers
current_usage_count      : 3
max_supported_count      : 3
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 100
severity                 : INFO

usage_type               : NUMBER_OF_CONTROLLERS
display_name             : Controllers
current_usage_count      : 3
max_supported_count      : 3
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 100
severity                 : INFO

usage_type               : NUMBER_OF_LOGICAL_SWITCHES
display_name             : Logical Switches
current_usage_count      : 1
max_supported_count      : 10000
min_threshold_percentage : 50
max_threshold_percentage : 80
current_usage_percentage : 0,01
severity                 : INFO

[...]
```

if you get a warning about `Unable to connect` Look [Issue](#issue)

to get API uri, go to NSXT Swagger (https://NSXT-IP/policy/api.html)

### Manage Tags on (Fabric) Virtual Machines

You can Add or Set tag(s) /scope to Virtual Machines

```powershell
# For add a tag myTag to a VM named myVM
Get-NSXTFabricVirtualMachines -display_name myVM | Add-NSXTFabricVirtualMachines -tag myTag

host_id          : 0de21662-6ab1-4e10-a503-95fb3371e29e
source           : @{target_id=0de21662-6ab1-4e10-a503-95fb3371e29e; target_display_name=nsxt-esxi1.lab.intra;
                   target_type=HostNode; is_valid=True}
external_id      : 5010d8d7-1d7e-f1df-dcd4-7919fadce87d
power_state      : VM_STOPPED
local_id_on_host : 1
compute_ids      : {moIdOnHost:1, hostLocalId:1, locationId:, instanceUuid:5010d8d7-1d7e-f1df-dcd4-7919fadce87d…}
type             : REGULAR
guest_info       :
resource_type    : VirtualMachine
display_name     : myVM
tags             : {@{scope=; tag=myTag}}
_last_sync_time  : 1564995660193

# For add a Second tag MyTag2 with scope myScope2
Get-NSXTFabricVirtualMachines -display_name myTag | Add-NSXTFabricVirtualMachines -tag myTag2 -scope myScope2

host_id          : 0de21662-6ab1-4e10-a503-95fb3371e29e
source           : @{target_id=0de21662-6ab1-4e10-a503-95fb3371e29e; target_display_name=nsxt-esxi1.lab.intra;
                   target_type=HostNode; is_valid=True}
external_id      : 5010d8d7-1d7e-f1df-dcd4-7919fadce87d
power_state      : VM_STOPPED
local_id_on_host : 1
compute_ids      : {moIdOnHost:1, hostLocalId:1, locationId:, instanceUuid:5010d8d7-1d7e-f1df-dcd4-7919fadce87d…}
type             : REGULAR
guest_info       :
resource_type    : VirtualMachine
display_name     : myVM
tags             : {@{scope=myScope2; tag=myTag2}, @{scope=; tag=myTag1}}
_last_sync_time  : 1564995660256

#For (Re) Configure Tag

Get-NSXTFabricVirtualMachines -display_name myTag | Set-NSXTFabricVirtualMachines -tag myTag3, MyTag4 -scope myScope3

host_id          : 0de21662-6ab1-4e10-a503-95fb3371e29e
source           : @{target_id=0de21662-6ab1-4e10-a503-95fb3371e29e; target_display_name=nsxt-esxi1.lab.intra;
                   target_type=HostNode; is_valid=True}
external_id      : 5010d8d7-1d7e-f1df-dcd4-7919fadce87d
power_state      : VM_STOPPED
local_id_on_host : 1
compute_ids      : {moIdOnHost:1, hostLocalId:1, locationId:, instanceUuid:5010d8d7-1d7e-f1df-dcd4-7919fadce87d…}
type             : REGULAR
guest_info       :
resource_type    : VirtualMachine
display_name     : myVM
tags             : {@{scope=myScope3; tag=myTag3}, @{scope=; tag=myTag4}}
_last_sync_time  : 1564995660328

#For Remove (Hack !) ALL Tag

Get-NSXTFabricVirtualMachines -display_name myTag | Set-NSXTFabricVirtualMachines -tags @()

host_id          : 0de21662-6ab1-4e10-a503-95fb3371e29e
source           : @{target_id=0de21662-6ab1-4e10-a503-95fb3371e29e; target_display_name=nsxt-esxi1.lab.intra;
                   target_type=HostNode; is_valid=True}
external_id      : 5010d8d7-1d7e-f1df-dcd4-7919fadce87d
power_state      : VM_STOPPED
local_id_on_host : 1
compute_ids      : {moIdOnHost:1, hostLocalId:1, locationId:, instanceUuid:5010d8d7-1d7e-f1df-dcd4-7919fadce87d…}
type             : REGULAR
guest_info       :
resource_type    : VirtualMachine
display_name     : myVM
tags             : {}
_last_sync_time  : 1564995660328
```

### Transport Zones

You can Add, Set and Remove Transport Zones

```powershell
#Add Transport Zone MyTZ-Vlan (type Vlan)

    Add-NSXTTransportZones -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name MyTZ-Vlan

    transport_type             : VLAN
    host_switch_name           : NVDS-psNSXT
    host_switch_id             : 87a134f7-b366-4e31-ba10-7421dfc88ccb
    transport_zone_profile_ids : {@{resource_type=BfdHealthMonitoringProfile;
                                profile_id=52035bb3-ab02-4a08-9884-18631312e50a}}
    host_switch_mode           : STANDARD
    nested_nsx                 : False
    is_default                 : False
    resource_type              : TransportZone
    id                         : 94d2ee8d-9a98-4954-8993-913cf37bbff8
    display_name               : MyTZ-Vlan
    _create_user               : admin
    _create_time               : 1587314452652
    _last_modified_user        : admin
    _last_modified_time        : 1587314452652
    _system_owned              : False
    _protection                : NOT_PROTECTED
    _revision                  : 0
    _schema                    : /v1/schema/TransportZone

#Add Transport Zone MyTZ-Overlay (type Overlay)
    Add-NSXTTransportZones -transport_type OVERLAY -host_switch_name NVDS-psNSXT -display_name MyTZ-Overlay

    transport_type             : OVERLAY
    host_switch_name           : NVDS-psNSXT
    host_switch_id             : 87a134f7-b366-4e31-ba10-7421dfc88ccb
    transport_zone_profile_ids : {@{resource_type=BfdHealthMonitoringProfile;
                                profile_id=52035bb3-ab02-4a08-9884-18631312e50a}}
    host_switch_mode           : STANDARD
    nested_nsx                 : False
    is_default                 : False
    resource_type              : TransportZone
    id                         : dcc64ab7-666d-4567-bf35-61d7521bd488
    display_name               : MyTZ-Overlay
    _create_user               : admin
    _create_time               : 1587314562671
    _last_modified_user        : admin
    _last_modified_time        : 1587314562671
    _system_owned              : False
    _protection                : NOT_PROTECTED
    _revision                  : 0
    _schema                    : /v1/schema/TransportZone


#Get list of all available Transport Zone

    Get-NSXTTransportZones | Format-Table

    transport_type host_switch_name id                                   host_switch_mode display_name
    -------------- ---------------- --------------                       ---------------- ------------
    OVERLAY        NVDS-psNSXT      dcc64ab7-666d-4567-bf35-61d7521bd488 STANDARD         MyTZ-Overlay
    VLAN           NVDS-psNSXT      94d2ee8d-9a98-4954-8993-913cf37bbff8 STANDARD         MyTZ-Vlan

#Get Transport Zone Vlan by display_name

    Get-NSXTTransportZones -display_name MyTZ-Vlan

    transport_type             : VLAN
    host_switch_name           : NVDS-psNSXT
    host_switch_id             : 87a134f7-b366-4e31-ba10-7421dfc88ccb
    transport_zone_profile_ids : {@{resource_type=BfdHealthMonitoringProfile; profile_id=52035bb3-ab02-4a08-9884-18631312e50a}}
    host_switch_mode           : STANDARD
    nested_nsx                 : False
    is_default                 : False
    resource_type              : TransportZone
    id                         : 94d2ee8d-9a98-4954-8993-913cf37bbff8
    display_name               : MyTZ-Vlan
    _create_user               : admin
    _create_time               : 1587314452652
    _last_modified_user        : admin
    _last_modified_time        : 1587314452652
    _system_owned              : False
    _protection                : NOT_PROTECTED
    _revision                  : 0
    _schema                    : /v1/schema/TransportZone

#Get Transport Zone Overlay by (zone_)id with summary

    Get-NSXTTransportZones -zone_id dcc64ab7-666d-4567-bf35-61d7521bd488 -summary

    transport_zone_id                    num_transport_nodes num_logical_switches num_logical_ports
    -----------------                    ------------------- -------------------- -----------------
    dcc64ab7-666d-4567-bf35-61d7521bd488                   0                    0                 0

#Remove Transport Zone
    Get-NSXTTransportZones -display_name MyTZ-Vlan | Remove-NSXTTransportZones

```

### Segments

You can Add, Set and Remove Segments (Type VLAN Only)

```powershell
#Add a (vlan) Segment MySegment on MyTZ-Vlan with vlan id 2

    Get-NSXTTransportZones -display_name MyTZ-Vlan | Add-NSXTPolicyInfraSegments -segment MySegment -vlan_ids 2

    type                : DISCONNECTED
    vlan_ids            : {2}
    transport_zone_path : /infra/sites/default/enforcement-points/default/transport-zones/e5bbefbc-a069-4101-a0b6-67a322e5e133
    resource_type       : Segment
    id                  : MySegment
    display_name        : MySegment
    path                : /infra/segments/MySegment
    relative_path       : MySegment
    parent_path         : /infra/segments/MySegment
    marked_for_delete   : False
    _create_user        : admin
    _create_time        : 1587741128335
    _last_modified_user : admin
    _last_modified_time : 1587741128335
    _system_owned       : False
    _protection         : NOT_PROTECTED
    _revision           : 0

#Change Vlan id of a Segment

    Get-NSXTPolicyInfraSegments -display_name MySegment | Set-NSXTPolicyInfraSegments -vlan_ids 23

    type                : DISCONNECTED
    vlan_ids            : {23}
    transport_zone_path : /infra/sites/default/enforcement-points/default/transport-zones/e5bbefbc-a069-4101-a0b6-67a322e5e133
    resource_type       : Segment
    id                  : MySegment
    display_name        : MySegment
    path                : /infra/segments/MySegment
    relative_path       : MySegment
    parent_path         : /infra/segments/MySegment
    marked_for_delete   : False
    _create_user        : admin
    _create_time        : 1587741369803
    _last_modified_user : admin
    _last_modified_time : 1587741376356
    _system_owned       : False
    _protection         : NOT_PROTECTED
    _revision           : 1

#Remove Segment

    Get-NSXTPolicyInfraSegments -display_name MySegment | Remove-NSXTPolicyInfraSegments

```

### VIFS

You can the the list of VIFS (Virtual InterFaceS)

```powershell
    Get-NSXTFabricVifs

    external_id         : 50100001-c249-c3bd-b338-95ffde75dcbf-4000
    owner_vm_id         : 50100001-c249-c3bd-b338-95ffde75dcbf
    owner_vm_type       : REGULAR
    host_id             : 3e36c43d-37a7-464f-83d8-9ecd6c62ac8d
    vm_local_id_on_host : 21
    device_key          : 4000
    device_name         : Network adapter 1
    mac_address         : 00:50:56:90:20:91
    ip_address_info     : {@{source=VM_TOOLS; ip_addresses=System.Object[]}}
    resource_type       : VirtualNetworkInterface
    display_name        : Network adapter 1
    _last_sync_time     : 1601838667905

    external_id         : 502ef9e8-7e39-0b61-965b-d7c4dbff0540-4000
    owner_vm_id         : 502ef9e8-7e39-0b61-965b-d7c4dbff0540
    owner_vm_type       : REGULAR
    host_id             : 3e36c43d-37a7-464f-83d8-9ecd6c62ac8d
    vm_local_id_on_host : 8
    device_key          : 4000
    device_name         : Network adapter 1
    mac_address         : 00:50:56:ae:68:16
    ip_address_info     : {@{source=VM_TOOLS; ip_addresses=System.Object[]}}
    resource_type       : VirtualNetworkInterface
    display_name        : Network adapter 1
    _last_sync_time     : 1600084236078
...
```

You can filter by host_id, lport_attachment_id or owner_vm_id

### Logical Switches

You can the the list of Logical Switches

```powershell
    Get-NSXTLogicalSwitches

    switch_type           : DEFAULT
    transport_zone_id     : af9bed19-6b4a-4790-8a93-c7a20d88ce3c
    vlan                  : 2011
    admin_state           : UP
    address_bindings      : {}
    switching_profile_ids : {@{key=SwitchSecuritySwitchingProfile; value=fbc4fb17-83d9-4b53-a286-ccdf04301888},
                            @{key=SpoofGuardSwitchingProfile; value=fad98876-d7ff-11e4-b9d6-1681e6b88ec1},
                            @{key=IpDiscoverySwitchingProfile; value=0c403bc9-7773-4680-a5cc-847ed0f9f52e},
                            @{key=MacManagementSwitchingProfile; value=1e7101c8-cfef-415a-9c8c-ce3d8dd078fb}…}
    hybrid                : False
    span                  : {}
    resource_type         : LogicalSwitch
    id                    : fa6c37d8-b13a-48e8-8325-093ec86233e2
    display_name          : NSXT-VLAN-2011
    tags                  : {@{scope=policyPath; tag=/infra/segments/NSXT-VLAN-2011}}
    _create_user          : nsx_policy
    _create_time          : 1600108586879
    _last_modified_user   : nsx_policy
    _last_modified_time   : 1600108586879
    _system_owned         : False
    _protection           : REQUIRE_OVERRIDE
    _revision             : 0
    _schema               : /v1/schema/LogicalSwitch
...
```

You can filter by display_name, transport_zone_id, vlan or switching_profile_id

### Transport Nodes

You can the the list of Transport Nodes

```powershell
 Get-NSXTTransportNodes

    node_id                  : 059eec67-514f-49ff-902f-3e6e48087f06
    host_switch_spec         : @{host_switches=System.Object[]; resource_type=StandardHostSwitchSpec}
    transport_zone_endpoints : {}
    maintenance_mode         : DISABLED
    node_deployment_info     : @{deployment_type=VIRTUAL_MACHINE; deployment_config=; node_settings=;
                            resource_type=EdgeNode; id=059eec67-514f-49ff-902f-3e6e48087f06;
                            display_name=NSXT-EDGE1; external_id=059eec67-514f-49ff-902f-3e6e48087f06;
                            ip_addresses=System.Object[]; _create_user=admin; _create_time=1600109960772;
                            _last_modified_user=admin; _last_modified_time=1600110236974; _system_owned=False;
                            _protection=NOT_PROTECTED; _revision=2}
    is_overridden            : False
    failure_domain_id        : 4fc1e3b0-1cd4-4339-86c8-f76baddbaafb
    resource_type            : TransportNode
    id                       : 059eec67-514f-49ff-902f-3e6e48087f06
    display_name             : NSXT-EDGE1
    description              :
    tags                     : {}
    _create_user             : admin
    _create_time             : 1600109961176
    _last_modified_user      : admin
    _last_modified_time      : 1600110237148
    _system_owned            : False
    _protection              : NOT_PROTECTED
    _revision                : 1

    node_id                  : 408e7237-995f-4f66-b1b6-4c5649f152eb
    host_switch_spec         : @{host_switches=System.Object[]; resource_type=StandardHostSwitchSpec}
    transport_zone_endpoints : {}
    maintenance_mode         : DISABLED
    node_deployment_info     : @{os_type=ESXI; os_version=7.0.0; managed_by_server=;
                            discovered_node_id=9812dfdb-82b4-450c-93fa-236210348a78:host-12; resource_type=HostNode;
                            id=408e7237-995f-4f66-b1b6-4c5649f152eb; display_name=VSAN01.psNSXT;
                            description=; tags=System.Object[]; external_id=408e7237-995f-4f66-b1b6-4c5649f152eb;
                            fqdn=VSAN01.psNSXT.intra; ip_addresses=System.Object[];
                            discovered_ip_addresses=System.Object[]; _create_user=admin; _create_time=1600084021602;
                            _last_modified_user=admin; _last_modified_time=1600108187045; _protection=NOT_PROTECTED;
                            _revision=1}
    is_overridden            : False
    resource_type            : TransportNode
    id                       : 408e7237-995f-4f66-b1b6-4c5649f152eb
    display_name             : VSAN01.psNSXT
    _create_user             : admin
    _create_time             : 1600101500538
    _last_modified_user      : admin
    _last_modified_time      : 1600196769240
    _system_owned            : False
    _protection              : NOT_PROTECTED
    _revision                : 4
...
```

You can filter by display_name, transport_zone_id, node_id, node_ip or in_maintenance_mode

### MultiConnection

Tt is possible to connect on same times to multi NSX-T manager
You need to use -connection parameter to cmdlet

For example to get Transport Zones of 2 NSX-T Manager

```powershell
# Connect to first NSX-T Manager
    $nsxt1 = Connect-NSXT 192.0.2.1 -SkipCertificateCheck -DefaultConnection:$false

#DefaultConnection set to false is not mandatory but only don't set the connection info on global variable

# Connect to first NSX-T Manager
    $nsxt2 = Connect-NSXT 192.0.2.2 -SkipCertificateCheck -DefaultConnection:$false

# Get Transport Zones for first NSX-T Manager
    Get-NSXTTransportZones -connection $nsxt1 | select transport_type, host_switch_name, host_switch_id, display_name

    transport_type host_switch_name host_switch_id                       display_name
    -------------- ---------------- --------------                       ------------
    OVERLAY        NVDS-psNSXT      87a134f7-b366-4e31-ba10-7421dfc88ccb MyTZ-Overlay
    VLAN           ALG-NVDS         ff40afe1-9bec-4c98-99f7-08f20f565c2d MyTZ-Vlan
....

# Get Transport Zones for first NSX-T Manager
    Get-NSXTTransportZones -connection $nsxt2 | select transport_type, host_switch_name, host_switch_id, display_name

    transport_type host_switch_name host_switch_id                       display_name
    -------------- ---------------- --------------                       ------------
    VLAN           NVDS-LAB         c1b7f689-764a-4c65-bd04-bbcdc204a855 TZ-VLAN
...

#Each cmdlet can use -connection parameter

```

### Disconnecting

```powershell
# Disconnect from the NSX-T Manager
    Disconnect-NSXT
```

# Issue

## Unable to connect (certificate)
if you use `Connect-NSXT` and get `Unable to Connect (certificate)`

The issue coming from use Self-Signed or Expired Certificate for management

Try to connect using `Connect-NSXT -SkipCertificateCheck`

# How to contribute

Contribution and feature requests are more than welcome. Please use the following methods:

  * For bugs and [issues](https://github.com/psNSXT/psNSXT/issues), please use the [issues](https://github.com/psNSXT/psNSXT/issues) register with details of the problem.
  * For Feature Requests, please use the [issues](https://github.com/psNSXT/psNSXT/issues) register with details of what's required.
  * For code contribution (bug fixes, or feature request), please request fork psNSXT, create a feature/fix branch, add tests if needed then submit a pull request.

# Contact

Currently, [@alagoutte](#author) started this project and will keep maintaining it. Reach out to me via [Twitter](#author), Email (see top of file) or the [issues](https://github.com/psNSXT/psNSXT/issues) Page here on GitHub. If you want to contribute, also get in touch with me.

# List of available command
```powershell
Add-NSXTFabricVirtualMachines
Add-NSXTLogicalPorts
Add-NSXTPolicyInfraSegments
Add-NSXTTransportZones
Confirm-NSXTFabricVifs
Confirm-NSXTFabricVirtualMachines
Confirm-NSXTLogicalPorts
Confirm-NSXTLogicalSwitches
Confirm-NSXTSegments
Confirm-NSXTTransportNodes
Confirm-NSXTTransportZones
Connect-NSXT
Disconnect-NSXT
Get-NSXTFabricVifs
Get-NSXTFabricVirtualMachines
Get-NSXTLogicalPorts
Get-NSXTLogicalSwitches
Get-NSXTPolicyInfraSegments
Get-NSXTTransportNodes
Get-NSXTTransportZones
Invoke-NSXTRestMethod
Move-NSXTTransportNodes
Remove-NSXTLogicalPorts
Remove-NSXTPolicyInfraSegments
Remove-NSXTTransportZones
Set-NSXTCipherSSL
Set-NSXTFabricVirtualMachines
Set-NSXTLogicalPorts
Set-NSXTPolicyInfraSegments
Set-NSXTTransportZones
Set-NSXTUntrustedSSL
Show-NSXTException
```

# Author

**Alexis La Goutte**
- <https://github.com/alagoutte>
- <https://twitter.com/alagoutte>

# Special Thanks

- Warren F. for his [blog post](http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/) 'Building a Powershell module'
- Erwan Quelin for help about Powershell

# License

Copyright 2019 Alexis La Goutte and the community.
