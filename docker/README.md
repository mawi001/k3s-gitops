# Docker images

## Vault

https://hub.docker.com/repository/docker/mwillemsma/vault-arm/

Build

Image was build on RPI4/4G

```sh
pi@raspberrypi:~/docker/vault $ uname -a
Linux raspberrypi 5.4.51-v7l+ #1333 SMP Mon Aug 10 16:51:40 BST 2020 armv7l GNU/Linux
```


```sh
pi@raspberrypi:~/docker/vault $ docker build . -t mwillemsma/vault-arm --build-arg VAULT_VERSION=1.5.4
Sending build context to Docker daemon  3.072kB
Step 1/6 : ARG VAULT_VERSION
Step 2/6 : FROM arm32v6/vault:${VAULT_VERSION}
 ---> dd760044ad28
Step 3/6 : RUN mkdir -p /opt/vault &&     apk add --no-cache nmap-ncat jq bash
 ---> Using cache
 ---> 23e0085dc644
Step 4/6 : COPY run.sh /opt/vault/run.sh
 ---> 6fad56391743
Step 5/6 : RUN chmod +x /opt/vault/run.sh
 ---> Running in 9a48e43c7b13
Removing intermediate container 9a48e43c7b13
 ---> 418f565f85ff
Step 6/6 : CMD ["/bin/bash", "/opt/vault/run.sh"]
 ---> Running in 1aa0433d85f9
Removing intermediate container 1aa0433d85f9
 ---> 05b131fb8c2e
Successfully built 05b131fb8c2e
Successfully tagged mwillemsma/vault-arm:latest
```

Tag

```sh
pi@raspberrypi:~/docker/vault $ docker tag mwillemsma/vault-arm mwillemsma/vault-arm:1.0.0
```

Push

```sh
pi@raspberrypi:~/docker/vault $ docker push mwillemsma/vault-arm:1.0.0
The push refers to repository [docker.io/mwillemsma/vault-arm]
601d9722cc2b: Pushed
ff6e20f8a3d5: Pushed
2d884f8b3a19: Pushed
566c08324a7e: Mounted from arm32v6/vault
309b0e8c7727: Mounted from arm32v6/vault
c7dede36d4fa: Mounted from arm32v6/vault
793b8fe135db: Mounted from arm32v6/vault
ffd5df06f331: Mounted from arm32v6/vault
1.0.0: digest: sha256:751c90a2e3f73ce66b1dfc2d33d4060c472ed6bd35152442ab5fb73e868adfbf size: 1988
```
