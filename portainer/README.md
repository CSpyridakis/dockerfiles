# Portainer 

```
docker run -d \
	--name portainer \
	-p 9000:9000 \
	--restart always \
  	-v /var/run/docker.sock:/var/run/docker.sock \
  	portainer/portainer
```