# Redis

1. Server
```
docker run -d --rm \
	--name redis \
	-p 6379:6379 \
	redis
```

2. Client
```
docker run -it --rm \
	--network=host \
	redis \
	redis-cli -h 127.0.0.1 # ADD HERE THE HOSTNAME
```