# Firefox

1. With appdata
```
docker run -d --rm \
	--name firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    jlesage/firefox
```

2. Without appdata
```
docker run -d --rm \
	--name firefox \
    -p 5800:5800 \
    jlesage/firefox
```