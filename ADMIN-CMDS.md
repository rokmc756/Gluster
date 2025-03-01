
### It may a permission problem. Could you try if it can be resolved by set auth.allow:
- https://stackoverflow.com/questions/20070717/glusterfs-denied-mount
```
$ gluster volume set ARCHIVE80 auth.allow 'SERVER1IPADDRESS'
```



```
$ gluster volume status all
Status of volume: distvol01
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick co9-node01:/glusterfs01/jbrick01      53261     0          Y       248048
Brick co9-node02:/glusterfs01/jbrick01      58586     0          Y       203517
Brick co9-node03:/glusterfs01/jbrick01      57937     0          Y       200885
Brick co9-node01:/glusterfs01/jbrick02      52801     0          Y       248063
Brick co9-node02:/glusterfs01/jbrick02      59157     0          Y       203532
Brick co9-node03:/glusterfs01/jbrick02      59776     0          Y       200900
```

```
$ gluster volume heal distvol01
Launching heal operation to perform index self heal on volume distvol01 has been unsuccessful:
Self-heal-daemon is disabled. Heal will not be triggered on volume distvol01
```


```
$ gluster volume bitrot distvol01 scrub status
Bitrot command failed : Bitrot is not enabled on volume distvol01
```

```
./conn-gluster.sh 171 "sysctl kernel.io_uring_disabled=0"
```


```
gluster volume set distvol01 storage.owner-uid 36
gluster volume set distvol01 storage.owner-gid 36
```

