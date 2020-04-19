# psNSXT

This is a Powershell module for configure a NSX-T (Manager).

With this module (version 0.1.0) you can manage:

- [Manage Tags](#manage-tags-on-fabric-virtual-machines) on (Fabric) Virtual Machines

There is some extra feature :

- [Invoke API](#Invoke-API) using Invoke-NSXTRestMethod

More functionality will be added later.

Tested with NSX-T (using 2.4.x and 2.5.x release) on Windows/Linux/macOS

# Usage

All resource management functions are available with the Powershell verbs GET, ADD, SET, REMOVE.
For example, you can manage Tag on (Fabric) Virtual Machines with the following commands:
- `Get-NSXTFabricVirtualMachines`
- `Add-NSXTFabricVirtualMachines`
- `Set-NSXTFabricVirtualMachines`
<!--
- `Remove-NSXTVlans`
-->

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

if you get a warning about `Unable to connect` Look [Issue](#Issue)

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

  * For bugs and [issues](https://github.com/alagoutte/psNSXT/issues), please use the [issues](https://github.com/alagoutte/psNSXT/issues) register with details of the problem.
  * For Feature Requests, please use the [issues](https://github.com/alagoutte/psNSXT/issues) register with details of what's required.
  * For code contribution (bug fixes, or feature request), please request fork psNSXT, create a feature/fix branch, add tests if needed then submit a pull request.

# Contact

Currently, @alagoutte started this project and will keep maintaining it. Reach out to me via [Twitter](#Author), Email (see top of file) or the [issues](https://github.com/alagoutte/psNSXT/issues) Page here on GitHub. If you want to contribute, also get in touch with me.

# List of available command
```powershell
Add-NSXTFabricVirtualMachines
Confirm-NSXTFabricVirtualMachines
Connect-NSXT
Disconnect-NSXT
Get-NSXTFabricVirtualMachines
Invoke-NSXTRestMethod
Set-NSXTCipherSSL
Set-NSXTFabricVirtualMachines
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
