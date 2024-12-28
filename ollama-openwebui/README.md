
# See: [Ollama instructions](https://ollama.com/blog/ollama-is-now-available-as-an-official-docker-image)

1. Install [Nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installation)

2. Run Ollama
```
docker run -d \
    --gpus=all \
    -v ollama:/root/.ollama \
    -p 11434:11434 \
    --name ollama \
    ollama/ollama
```

3. Run model
```
docker exec -it ollama ollama run llama2
```
