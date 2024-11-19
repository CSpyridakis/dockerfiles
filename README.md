# DOCKERFILES

## Good 

### Portainer 
```
docker run -d \
	-p 9000:9000 \
  	-v /var/run/docker.sock:/var/run/docker.sock \
  	portainer/portainer
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
    --name=firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    jlesage/firefox
```

2. Without appdata
```
docker run -d \
    --name=firefox \
    -p 5800:5800 \
    jlesage/firefox
```
