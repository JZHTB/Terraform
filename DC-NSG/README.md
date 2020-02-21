# DC NSG Module

This module will create a new NSG with the required rules to enable DC traffic in a hub/spoke model. 

The Module requires you to provide an existing resource Group, deployment location and a spoke IP range and the domain controller range. 

Optionally you can provide a number of switches to configure a number of additional subnet rules and provide new tags. 

Sample Call: 


```
nsg-name                   = nsg-newNSG
resource-group-name        = rg-nameOfExistingRG
location                   = uksouth 
spoke-ip-range             = "8.8.8.8" or ["8.8.8.8" , "8.8.8.8"]
domain_controller-ip-range = "8.8.8.8" or ["8.8.8.8" , "8.8.8.8"]

enable-rdp                 = true
rdp-source-range           = ["10.11.12.13", "192.168.1.10"]
tags = {
              buisnessUnit = IT
                costCentre = 12341234
}
```


## Required Vars
| Variable | Type | Description|
|----------|------|------------|
| nsgName | string   | The name of the NSG to be created|
| resource_group_name| string | The name of the existing RG |
| location | string |Azure location for the deployment|
| spoke_ip_range | string |  A range or a list of ranges to allow DC traffic to and from.  |
| domain_controller_ip_range | string |  A range or a list of ranges to allow DC traffic to and from. Additional rules such as vnet-deny and RDP allow will apply to this range  |

## Optional Vars
| Variable | Type | Description|
|----------|------|------------|
| tags| map(string) |A map of tags to apply to the resource. |
| lockdown_vnet| bool |Default: false. When enabled all traffic with the subnet designated above as *domain_controller_ip_range* will be blocked. |
| enableRDP | bool |Default: false. When enabled port 3389 is opened to traffic from the *rdp_source_range* |
| rdp_source_range | string |Default: "" .  The range that is applied when enable_rdp is enabled. This can be a range or a list of CIDR ranges. |

