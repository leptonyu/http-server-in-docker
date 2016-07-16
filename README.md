Simple http static file server in Docker 
===


Use the simple golang http server 

pull from docker.io

```
docker pull icymint/http
```


run server

```
docker run --rm --name test -v "$PWD":/docker -p 3000:3000 icymint/http
```

