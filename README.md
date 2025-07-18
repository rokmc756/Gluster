### What is this Ansible Playbook for Gluster
It is Ansible Playbook to deploy Gluster with many services such as GlusterFS/NFS Ganesha/Samba for CentOS 9.x.
The purpose of this is only for development environment not production.

### What is Gluster?
Gluster is a scalable, distributed file system that aggregates disk storage resources from multiple servers into a single global namespace.
#### Advantages
- Scales to several petabytes
- Handles thousands of clients
- POSIX compatible
- Uses commodity hardware
- Can use any ondisk filesystem that supports extended attributes
- Accessible using industry standard protocols like NFS and SMB
- Provides replication, quotas, geo-replication, snapshots and bitrot detection
- Allows optimization for different workloads
- Open Source

### Gluster Architecture
#### Scale Up and Out Diagram
![alt text](https://raw.githubusercontent.com/rokmc756/gluster/main/roles/gluster/images/gluster_diagram.png)
#### Internal Flow
![alt text](https://raw.githubusercontent.com/rokmc756/gluster/main/roles/gluster/images/gluster-file-system-architecture.png)

### Gluster Volume Types
#### Distributed
Distributed volumes distribute files across the bricks in the volume where the requirement is to scale storage and the redundancy is either not important or is provided by other hardware/software layers.
#### Replicated
Replicated volumes replicate files across bricks in the volume where environments that high-availability and high-reliability are critical.
#### Distributed Replicated
Distributed replicated volumes distribute files across replicated bricks in the volume where environments that the requirement is to scale storage and high-reliability is critical. Distributed replicated volumes also offer improved read performance in most environments.
#### Dispersed
Dispersed volumes are based on erasure codes, providing space-efficient protection against disk or server failures. It stores an encoded fragment of the original file to each brick in a way that only a subset of the fragments is needed to recover the original file. The number of bricks that can be missing without losing access to data is configured by the administrator on volume creation time.
#### Distributed Dispersed
Distributed dispersed volumes distribute files across dispersed subvolumes. This has the same advantages of distribute replicate volumes, but using disperse to store the data into the bricks.

### Supported Platform and OS
Virtual Machines\
Baremetal\
Rocky Linux / CentOS Stream 9.x

### Prerequisite for Ansible Host
MacOS or Windows Linux Subsysetm or Many kind of Linux Distributions should have ansible as ansible host.\
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt

### Prepare Ansible Host to run this Ansible Playbook
* MacOS
```
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

* Fedora/CentOS/RHEL
```
$ yum install ansible
```

### Configure Inventory for Gluster
$ vi ansible-hosts-co9
```
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[control]
co9-node01      ansible_ssh_host=192.168.2.171

[workers]
co9-node01      ansible_ssh_host=192.168.2.171
co9-node02      ansible_ssh_host=192.168.2.172
co9-node03      ansible_ssh_host=192.168.2.173

[append]
co9-node02      ansible_ssh_host=192.168.2.172
co9-node03      ansible_ssh_host=192.168.2.173

[clients]
co9-node04      ansible_ssh_host=192.168.2.174
```
### Initialize Linux Hosts to create users and ssh keys to exchange them among all hosts
```
$ make hosts r=init s=all
```

### Uninitialize Linux Hosts to delete users and ssh keys in all hosts
```
$ make hosts r=uninit s=all
```


### Enable Gluster Package Repositories and Install Packages
```
$ make gluster r=enable s=repo

$ make gluster r=install s=pkgs
```

### Disable Gluster Package Repositories and Uninstall Packages
```
$ make gluster r=disable s=repo

$ make gluster r=uninstall s=pkgs
```


### Deploy Gluster
#### 1) Start Gluster Server
```
$ make gluster r=start s=server
```
#### 2) Probe Gluster Node
```
$ make gluster r=probe s=server c=peer
```

#### 3) Create Partition and Filesystem
```
$ make gluster r=create s=volume c=partition
```
#### 4) Create Gluster Volumes
```
$ make gluster r=create s=volume c=distribute
or
$ make gluster r=create s=volume c=replicate
or
$ make gluster r=create s=volume c=mixed
or
$ make gluster r=create s=volume c=disperse
```
#### 5) Enable Gluster Volumes Quata
```
$ make gluster r=enable s=volume c=quota
```
#### 6) Setup Gluster Client
```
$ make gluster r=setup s=client c=fs
```
#### 7) Enable Gluster Client Quota
```
$ make gluster r=enable s=volume c=cquota
```


### Destroy Gluster
#### 1) Disable Gluster Client Quota
```
$ make gluster r=disable s=volume c=cquota
```
#### 2) Remove Gluster Client
```
$ make gluster r=remove s=client c=fs
```
#### 3) Disable Gluster Volumes Quota
```
$ make gluster r=disable s=volume c=quota
```
#### 4) Delete Gluster Volumes
```
$ make gluster r=delete s=volume c=fs
```
#### 5) Delete Partition and Filesystem
```
$ make gluster r=delete s=volume c=partition
```
#### 6) Detach Gluster Node
```
$ make gluster r=detach s=server c=peer
```
#### 7) Stop Gluster Server
```
$ make gluster r=stop s=server
```

### Deploy NFS Ganesha Server
#### 1) Enable NFS Ganesha Package Repository
```
$ make ganesha r=enable s=repo
```
#### 2) Install NFS Ganesha Package
```
$ make ganesha r=install s=pkgs
```
#### 3) Start NFS Ganesha Server
```
$ make ganesha r=start s=server
```
#### 4) Setup NFS Ganesha Client
```
$ make ganesha r=setup s=client c=nfs
```


### Destroy NFS Ganesha Server
#### 1) Remove NFS Ganesha Client
```
$ make ganesha r=remove s=client c=nfs
```
#### 2) Stop NFS Ganesha Server
```
$ make ganesha r=stop s=server
```
#### 3) Uninstall NFS Ganesha Package
```
$ make ganesha r=uninstall s=pkgs
```
#### 4) Disable NFS Ganesha Package Repository
```
$ make ganesha r=disable s=repo
```

### Deploy Samba
#### 1) Enable Gluster Samaba Package Repository
```
$ make smb r=enable s=repo
```
#### 2) Install Gluster Samaba Package
```
$ make smb r=install s=pkgs
```
#### 3) Enable Gluster Samaba Mode
```
$ make smb r=enable  s=samba  c=mode
```
#### 4) Enable Gluster CTDB
```
$ make smb r=enable  s=samba  c=ctdb
```
#### 5) Enable Gluster Samaba Volumes
```
$ make smb r=enable  s=samba  c=volume
```
#### 6) Enable Gluster Samaba Shares
```
$ make smb r=enable  s=samba  c=share
```
#### 7) Add Gluster Samaba Users
```
$ make smb r=add     s=samba  c=user
```
#### 8) Enable Firewall adn SELinux
```
$ make smb r=enable  s=samba  c=sec
```
#### 9) Start Gluster Samaba Server
```
$ make smb r=start   s=samba  c=service
```
#### 10) Setup Gluster Samaba Cluster
```
$ make smb r=setup   s=samba  c=client
```

### Remove Samba on GlusterFS
#### 1) Remove Gluster Samaba Cluster
```
$ make smb r=remove  s=samba  c=client
```
#### 2) Stop Gluster Samaba Server
```
$ make smb r=stop    s=samba c=service
```
#### 3) Disable Firewall adn SELinux
```
$ make smb r=disable s=samba c=sec
```
#### 4) Delete Gluster Samaba Users
```
$ make smb r=delete  s=samba c=user
```
#### 5) Disable Gluster Samaba Shares
```
$ make smb r=disable s=samba c=share
```
#### 6) Disable Gluster Samaba Volumes
```
$ make smb r=disable s=samba c=volume
```
#### 7) Disable Gluster CTDB
```
$ make smb r=disable s=samba c=ctdb
```
#### 8) Disable Gluster Samaba Mode
```
$ make smb r=disable s=samba c=mode
```
#### 9) Uninstall Gluster Samaba Package
```
$ make smb r=uninstall  s=pkgs
```
#### 10) Disable Gluster Samaba Package Repository
```
$ make smb r=disable    s=repo
```

### TODO
#### 1) Need to check the following error would not be appeared after adding disks not use / directory
```
[root@co9-node01 ~]# gluster volume create vol_distributed transport tcp co9-node01:/glusterfs/distributed co9-node02:/glusterfs/distributed co9-node03:/glusterfs/distributed
volume create: vol_distributed: failed: The brick co9-node01:/glusterfs/distributed is being created in the root partition. It is recommended that you don't use the system's root partition for storage backend. Or use 'force' at the end of the command if you want to override this behavior.
```
#### 2) Need to check the Quota works correctly for all Volume Modes
#### 3) Issues
- https://github.com/gluster/glusterfs/issues/2347


### References
* https://www.server-world.info/en/note?os=CentOS_Stream_9&p=glusterfs11&f=1

