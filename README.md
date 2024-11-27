# DOCKERFILES

## Good 

### Portainer 
```
docker run -d \
	-p 9000:9000 \
	--restart always \
  	-v /var/run/docker.sock:/var/run/docker.sock \
  	portainer/portainer
```
### Open WebUI (https://github.com/open-webui/open-webui)
```
docker run -d \
	-p 3000:8080 \
	--add-host=host.docker.internal:host-gateway \
	-v open-webui:/app/backend/data \
	--name open-webui \
	--restart always \
	ghcr.io/open-webui/open-webui:main
```

### IT-TOOLS
```
docker run -d \
	-p 8080:80 \
	--name it-tools \
	-it \
	corentinth/it-tools
```

### Firefox

1. With appdata
```
docker run -d \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    jlesage/firefox
```

2. Without appdata
```
docker run -d \
    -p 5800:5800 \
    jlesage/firefox
```

### Grafana
```
docker run -d \
	-p 4000:3000 \
	grafana/grafana
```


### Nginx
```
docker run -d \
	-p 80:80 \
	nginx:latest
```


### Redis

1. Server
```
docker run -d \
	-p 6379:6379 \
	redis
```

2. Client
```
docker run -it \
	--network=host 
	redis \
	redis-cli -h 127.0.0.1 # ADD HERE THE HOSTNAME
```

===============================================================================
NOT TESTED

### Network-Multitool
```
docker run -it --rm \
    praqma/network-multitool \
    bash
```
