## What is this Ansible Playbook for Gluster
It is Ansible Playbook to deploy Gluster with many services such as GlusterFS/NFS Ganesha/Samba for CentOS 9.x.
The purpose of this is only for development environment not production.

## What is Gluster?
Gluster is a scalable, distributed file system that aggregates disk storage resources from multiple servers into a single global namespace.
### Advantages
- Scales to several petabytes
- Handles thousands of clients
- POSIX compatible
- Uses commodity hardware
- Can use any ondisk filesystem that supports extended attributes
- Accessible using industry standard protocols like NFS and SMB
- Provides replication, quotas, geo-replication, snapshots and bitrot detection
- Allows optimization for different workloads
- Open Source

## Gluster Architecture
### Scale Up and Out Diagram
![alt text](https://raw.githubusercontent.com/rokmc756/gluster/main/roles/gluster/images/gluster_diagram.png)
### Internal Flow
![alt text](https://raw.githubusercontent.com/rokmc756/gluster/main/roles/gluster/images/gluster-file-system-architecture.png)

## Supported Platform and OS
Virtual Machines\
Baremetal\
CentOS Stream 9.x

## Prerequisite for Ansible Host
MacOS or Windows Linux Subsysetm or Many kind of Linux Distributions should have ansible as ansible host.\
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt

## Prepare Ansible Host to run this Ansible Playbook
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

### Setup DNS with FreeIPA
#### 1) Configure Varialbes for DNS Zone and Records
```
---
_dns:
  zone:
    - { name: jtest.pivotal.io, type: forward }
    - { name: 2.168.192.in-addr.arpa, type: reverse }
  resource:
    forward:
      - {  name: "co9-node01",    i   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.171"  }
      - {  name: "co9-node02",    i   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.172"  }
      - {  name: "co9-node03",    i   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.173"  }
      - {  name: "co9-node04",    i   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.174"  }
      - {  name: "co9-node05",    i   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.175"  }
      - {  name: "co9-node06",    i   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.176"  }
      - {  name: "co9-node07",    i   zone: "okd4.pivotal.io",  type: "-a-rec",  value: "192.168.2.177"  }
    reverse:
      - { name: "171",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "co9-node02.pivotal.io."  }
      - { name: "172",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "co9-node03.pivotal.io."  }
      - { name: "173",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "co9-node04.pivotal.io."  }
      - { name: "174",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "co9-node05.pivotal.io."  }
      - { name: "175",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "co9-node06.pivotal.io."  }
      - { name: "176",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "co9-node07.pivotal.io."  }
      - { name: "177",  zone: 2.168.192.in-addr.arpa,  type: "--ptr-rec", value: "co9-node08.pivotal.io."  }
_selinux:
  policy:
    - { name: httpd_can_network_connect, toggle: on }
    - { name: httpd_gracefull_shutdown, toggle: on }
    - { name: httpd_can_network_relay, toggle: on }
  semange:
    - { name: port , type: http_port, proto: tcp, port: 6443 }
    - { name: port , type: http_port, proto: tcp, port: 22623 }
    - { name: port , type: http_port, proto: tcp, port: 1936 }


_firewall:
  service:
    - { name: dns,    state: enabled }
    - { name: http,   state: enabled }
    - { name: https,  state: enabled }
  port:
    - { state: enabled, port: 6443, proto: tcp, zone: public }
    - { state: enabled, port: 1936, proto: tcp, zone: public }
    - { state: enabled, port: 8080, proto: tcp, zone: public }
```

#### 2) Add DNS Zones and Records
```
$ make okd r=setup s=dns c=zone
$ make okd r=setup s=dns c=record
or
$ make okd r=setup s=dns c=all
```

#### 3) Remove DNS Zones and Records
```yaml
$ make okd r=remove s=dns c=record
$ make okd r=remove s=dns c=zone
or
$ make okd r=remove s=dns c=all
```

### Configure Inventory for Gluster
#### 1) Setup NFS Server
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

### Setup Gluster Nodes
#### 1) Start/Stop Gluster Server
```
$ make gluster r=start s=server

or
$ make gluster r=stop s=server
```

#### 2) Probe/Detach Gluster Node
```
$ make gluster r=probe s=server c=peer

or
$ make gluster r=detach s=server c=peer
```


#### 3) Create/Delete Gluster Volumes
```
$ make gluster r=create s=volume

or
$ make gluster r=delete s=volume
```

#### 4) Setup/Remove Gluster Client
```
$ make gluster r=setup s=client c=fs

or
$ make gluster r=remove s=client c=fs
```



#### 3) Setup/Remove NFS Server for oVirt NFS Storage Domain
```
$ make storage r=setup s=nfs c=server

or
$ make storage r=remove s=nfs c=server
```


### Setup Gluster NFS Server
```
$ make ganesha r=enable s=repo
$ make ganesha r=install s=pkgs
$ make ganesha r=start s=server
$ make ganesha r=setup s=client c=nfs
```


### Remove Gluster NFS Server
```
$ make ganesha r=remove s=client c=nfs
$ make ganesha r=stop s=server
$ make ganesha r=uninstall s=pkgs
$ make ganesha r=disable s=repo
```


## References


## Similar Playbook
## TODO
## Debugging
## Tracking Issues


## Errors
### Gluster Volume Creation Failure
```
[root@co9-node01 ~]# gluster volume create vol_distributed transport tcp co9-node01:/glusterfs/distributed co9-node02:/glusterfs/distributed co9-node03:/glusterfs/distributed
volume create: vol_distributed: failed: The brick co9-node01:/glusterfs/distributed is being created in the root partition. It is recommended that you don't use the system's root partition for storage backend. Or use 'force' at the end of the command if you want to override this behavior.
```
