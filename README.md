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

### GDU
```
docker run --rm \
    --init \
    --interactive \
    --tty \
    --privileged \
    --volume /:/mnt/root \
    ghcr.io/dundee/gdu \
    /mnt/root
```

### Open WebUI (https://github.com/open-webui/open-webui)
> [!WARNING]
> In order to work:
> 1. sudo vim /etc/systemd/system/ollama.service
> ```
> Environment="OLLAMA_HOST=0.0.0.0:11434"
> ```
> 2. Then restart ollama
> ```
> sudo systemctl daemon-reload
> sudo systemctl restart ollama
> ```
> 3. Make sure that your firewall accepts requests there
> ```
> sudo ufw allow 11434
> ```

1. CPU
```
docker run -d \
	-p 3000:8080 \
	--add-host=host.docker.internal:host-gateway \
	-v open-webui:/app/backend/data \
	--restart always \
	ghcr.io/open-webui/open-webui:main
```
2. GPU
> [!WARNING]
> In order to work:
> 1. Configure the repository:
> ```
> curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
> && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
> && sudo apt-get update
> ```
> 
> 2. Install the NVIDIA Container Toolkit packages:
> ```
> sudo apt-get install -y nvidia-container-toolkit
> ```
> 3. Configure the container runtime by using the nvidia-ctk command:
> ```
> sudo nvidia-ctk runtime configure --runtime=docker
> ```
> 4. Restart the Docker daemon:
> ```
> sudo systemctl restart docker
> ```
```
docker run -d \
	-p 3001:8080 \
	--gpus all \
	--add-host=host.docker.internal:host-gateway \
	-v open-webui:/app/backend/data \
 	--restart always \
	ghcr.io/open-webui/open-webui:cuda
```
===============================================================================
NOT TESTED

### Network-Multitool
```
docker run -it --rm \
    praqma/network-multitool \
    bash
```
