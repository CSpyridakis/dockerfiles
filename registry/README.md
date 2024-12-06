### Docker registry

1. With certs
```
docker run -d \
    -p 6002:5000 \
    --restart=always \
    -v `pwd`/data:/var/lib/registry \
    -v `pwd`/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
    registry:2
```

2. Without certs
```
docker run -d \
    -p 6003:5000 \
    --restart=always \
    -v `pwd`/data:/var/lib/registry \
    registry:2
```

#### Test registry
``` 
docker pull hello-world
docker tag hello-world localhost:6003/hello-world
docker push localhost:6003/hello-world
```