### Requirements

Before install bigdata frameworks, please make sure all below requirements are satisfied:

- This project is now only tested and working fine on Ubuntu 18.04, so first thing is to install Ubuntu 18.04 (live server) Operating System on all cluster nodes.
 
  If use Virtual Machines like VirtualBox, add two virtual network interfaces, one as NAT mode, another one as Host-only mode.

- Configure static IP address for each node (`netplan`)

  Example `netplan` configuration for VirtualBox VMs:
  
  ```yaml
    network:
      ethernets:
        enp0s3:
          dhcp4: no
          addresses: [10.0.2.7/24,]
          gateway4: 10.0.2.2
          nameservers:
            addresses: [10.0.2.2]
        enp0s8:
          dhcp4: no
          addresses: [192.168.56.101/24,]
      version: 2
  ```

- Install OpenJDK 8 on all cluster nodes

- Set JAVA_HOME in /etc/profile

- Add $JAVA_HOME/bin in PATH environment