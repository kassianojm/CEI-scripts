# CEI-scripts
Some useful scripts.

This repository helps CEI Users' to deploy distributed applications.

The script to exchange ssh keys allows users to do a full exchange keys based on the VMs pool. The script needs to be executed at the personal computer (computer containing pkey used into OpenStack). Otherwise, it will not work.

Basically, fill nodefile with the OpenStack floating ips and execute the script ./script <user>.
  
The user need to be the same for every VM.
