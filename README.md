![](https://i.goopics.net/lq.png)

## Tag available
* lts, 8.9.3, 8.9, 8 [(Dockerfile)](https://github.com/pierexmachina/docker-node/blob/master/Dockerfile)
* lts-onbuild, 6.11.0-onbuild, 6.11-onbuild, 6-onbuild [(Dockerfile)](https://github.com/pierexmachina/docker-node/blob/master/Dockerfile.onbuild)

## Description
Node.js docker image for arm.  
Tested only on Raspberry Pi 3.  
Based on xataz node docker image https://github.com/xataz/docker-node  

## docker hub
[https://hub.docker.com/r/pierexmachina/node/] (https://hub.docker.com/r/pierexmachina/node/)

## Build Image

```shell
docker build -t pierexmachina/node github.com/pierexmachina/docker-node#master:latest
```

### Build other version
```shell
docker build -t pierexmachina/node:5.9.0 --build-arg NODE_VER=5.9.0 github.com/pierexmachina/docker-node#master:latest
```

## Usage
### Simple run
```
docker run -d -v $(pwd):/usr/app/src -w /usr/app/src pierexmachina/node:6 node app.js
```

### With onbuild
Create a Dockerfile on your project :
```
FROM pierexmachina/node:onbuild

```

And build this :
```
docker build -t myproject .
```
