### Prerequisites

Before install bigdata frameworks, please make sure all below requirements are satisfied:

- This project is now only tested and working fine on Ubuntu 18.04, so first thing is to install Ubuntu 18.04 (live server) Operating System on all cluster nodes.

  If use Virtual Machines like VirtualBox, add two virtual network interfaces, one as NAT mode, another one as Host-only mode.

- By default, after install Ubuntu 18.04, the root user ssh login is disabled. We should enable it and also allow password authentication.

  ```shell
  sudo vim /etc/ssh/sshd_config
  ```

  Add:

  ```shell
  PermitRootLogin yes
  PasswordAuthentication yes
  ```

  Save and restart ssh service

  ```shell
  sudo systemctl restart ssh
  ```

  Set password for root user

  ```shell
  sudo passwd root
  ```

  enter a password for the root user.

- Configure static IP address for each node (`netplan`)

  ```shell
  sudo vim /etc/netplan/50-cloud-init.yaml
  ```

  Set content like below, set unique IP adddress for each node

  ```yaml
    network:
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: no
          addresses: [192.168.56.101/24,]
      version: 2
  ```

  Save and  apply netplan changes

  ```shell
  sudo netplan apply
  ```

- Modify hostname as expected

  ```shell
  sudo vim /etc/hostname
  ```

  Modify and save, then restart VM to take effect.

- Set hostname and IP address mapping in `/etc/hosts`

  ```shell
  sudo vim /etc/hosts
  ```

  Add hostname and IP address mapping, then save

  ```shell
  192.168.56.101 bigdata01
  192.168.56.102 bigdata02
  192.168.56.103 bigdata03
  ```

- Set ssh key between nodes for both root and non-root users

  ```shell
  cd ~
  ssh-keygen
  cd ~/.ssh
  ssh-copy-id -i id_rsa.pub bigdata01
  ssh-copy-id -i id_rsa.pub bigdata02
  ssh-copy-id -i id_rsa.pub bigdata03
  ```

  repeat the steps on all nodes

- Install OpenJDK 8 on all cluster nodes

  ```shell
  sudo apt-get install openjdk-8-jdk-headless
  ```

- Set JAVA_HOME and PATH in /etc/profile

  ```shell
  su - root
  echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre" >> /etc/profile
  echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
  source /etc/profile
  ```

Now, all prerequisites are completed. We can go ahead to install bigdata frameworks by using the provided script `install.sh`