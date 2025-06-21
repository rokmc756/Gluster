# Gluster Web Interface

[gluster-web-interface](https://github.com/oss2016summer/gluster-web-interface) is Web UI to Manage GlusterFS.


## Build Docker Image
```bash
docker build -t gluster-web-ui:v1.0.0 .
```

## Pull the Image to Local

```bash
docker pull like/gluster-web-interface
```

## Run the Instance to Expose Port 3000

```bash
docker run -it -p 3000:3000 like/gluster-web-ui
```

Please open http://&lt;ip address&gt;:3000/ by browser to access gluster-web-interface.

