# Multipass

```shell
multipass launch docker --name node1
multipass ls
multipass shell node1
multipass delete node1
multipass purge
```

Setup Portainer within 5 minutes of Launch.
Login to `<IP>:9000` and...

-- node1 --

```json
{
 "username":"node1"
 "password":"docker.Swarm1"
}
```

-- node2 --

```json
{
 "username":"node2"
 "password":"docker.Swarm2"
}
```

-- node3 --

```json
{
 "username":"node3"
 "password":"docker.Swarm3"
}
```
