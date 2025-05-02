# Untested Commands

## Docker Filters

```shell
  docker images --filter label= # some label
```

## Mutable Tags

```shell
$ docker rmi alpine:latest
Untagged: alpine:latest
Untagged: alpine@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11
Deleted: sha256:44dd6f2230041eede4ee5e792728313e43921b3e46c1809399391535c0c0183b
Deleted: sha256:94dd7d531fa5695c0c033dcb69f213c2b4c3b5a3ae6e497252ba88da87169c3f

$ docker pull alpinesha256:02bb6f42...44c9b11
docker.io/library/alpine@sha256:02bb6f42...44c9b11: Pulling from library/alpine
08409d417260: Pull complete
Digest: sha256:02bb6f428431...9a33cb1af4444c9b11
Status: Downloaded newer image for alpine@sha256:02bb6f428431...9a33cb1af4444c9b11
docker.io/library/alpine@sha256:02bb6f428431...9a33cb1af4444c9b11

$ docker images | grep alpine # just couldn't see the hash
```

## See Manifest

```shell
$ docker manifest inspect golang | grep 'architecture\|os'
"architecture": "amd64",
"os": "linux"
"architecture": "arm",
"os": "linux",
"architecture": "arm64",
"os": "linux",
"architecture": "386",
"os": "linux"
"architecture": "mips64le",
"os": "linux"
"architecture": "ppc64le",
"os": "linux"
"architecture": "s390x",
"os": "linux"
"architecture": "amd64",
"os": "windows",
"os.version": "10.0.20348.1726"
"architecture": "amd64",
"os": "windows",
"os.version": "10.0.17763.4377"
```

## Nuke all images

```shell
docker rmi $(docker images -q) -f
```

## Docker Swarm

```sh
# Init Manager 1
docker swarm init \
  --advertise-addr 10.0.0.1:2377 \
  --listen-addr 10.0.0.1:2377
# advertise-addr: one of the node's IP addr or external load-balancer addr
# listen-addr: defaults to advertise-addr
# if advertise-addr is a load-balancer, you MUST specify --listen-addr

# List nodes in the swarm
docker node ls

# Get join token
docker swarm join-token worker
docker swarm join-token manager

# Join swarm
docker swarm join \
  --token ... \
  10.0.0.1:2377 \
  --advertise-addr 10.0.0.4:2377 \
  --listen-addr 10.0.0.4:2377
```

## Docker Swarm Security

```sh
# Autolock
docker swarm init --autolock
docker swarm update --autolock=true
# Encrypts TLS communication & Raft logs key with a third key.
# Restarts will fail. You must first unlock the swarm with the third key.
docker swarm unlock
# Tradeoff convenience vs security.

# Managers will be Managers
docker node update --availability drain manager1
docker node update --availability drain manager2
docker node update --availability drain manager3
# Managers will focus solely on control-plane duties.
```

## Docker service

```sh
# Create new docker service
docker service create \
  --name web-fe \
  -p 8080:8080 \
  --replicas 5 \
  nigelpoulton/ddd-book:web0.1

# List
docker service ls # list services
docker service ps web-fe # list tasks of one or more services

# Inspect
docker service inspect --pretty web-fe

# Scale
docker service scale web-fe=10

# Remove
docker service rm web-fe

# Zero downtime Rolling Update
docker service update \
  --image nigelpoulton/ddd-book:web0.2 \
  --update-parallelism 2 \
  --update-delay 20s \
  uber-svc
# update-parallelism: number of replicas to update at a time
# update-delay: delay between updates
# Example: update 2 replicas - wait 20s - update next 2 replicas - wait 20s ...
# These settings will be merged into
docker service inspect --pretty uber-svc
# for the next time.

# See logs
docker service logs --follow --tail --details
```

## Swarm Deployment

- Swarm init on all machines.
- Create service with given number of replicas.
- `docker service create --mode global` will run one replica per node instead.

## Swarm Backup

```sh
# Create a new network
docker network create -d overlay unimatrix01

# Stop docker on a non-leader manager
service docker stop
# Remember that you manager node shouldn't contain any worker.
# Keep a copy of unlock key if you locked the swarm.

# Backup the swarm config
tar -czvf swarm.bkp /var/lib/docker/swarm/

# Verify the backup file exists
ls -l

# Restart Docker
service docker restart

# Unlock the Swarm to admit the restarted manager.
# Run
docker swarm unlock-key
# on some other manager if you don't remember it.
docker swarm unlock
```

## Swarm Recover

You'll need `swarm.bkp` and a copy of your swarm's unlock key.

Requirements.
- You can only restore to a node running the same version of Docker the backup
was performed on.
- You can only restore to a node with the same IP address as the node the
backup was performed on.

```sh
# Stop Docker on the manager
service docker stop

# Delete the Swarm config.
rm -r /var/lib/docker/swarm

# Restore
tar -zxvf swarm.bkp -C /
ls /var/lib/docker/swarm
# certificates docker-state.json raft state.json worker

# Start Docker
service docker start

# Unlock Swarm with your Swarm unlock key.
docker swarm unlock

# Initialize the new Swarm with the configuration from the backup.
docker swarm init \
  --force-new-cluster \
  --advertise-addr 10.0.0.1:2377 \
  --listen-addr 10.0.0.1:2377

# Check that the unimatrix01 network was recovered as part of the operation.
docker network ls

# Add new managers and workers and take fresh backups
# You NEED to test this procedure regularly and thoroughly.
```

## Docker Swarm Commands

- `docker swarm init`
Creates a new swarm.
The node you run this command on becomes the first manager and is switched to
run in the swarm mode.

- `docker swarm join-token`
Reveals the commands and tokens needed to join workers and managers to a swarm.
For managers, it's `docker swarm join-token manager`.
For workers, it's `docker swarm join-token worker`.

- `docker node ls`
List all nodes in the swarm, including which are managers and which is the
leader.

- `docker service create`
Create a new service (requires swarm init).

- `docker service ls`
List running services; give *basic* info on the state of the service and any
running replicas.

- `docker service ps <service>`
Gives *more* detailed information about individual service replicas.

- `docker service inspect`
Gives *very* detailed information on a service.
Accepts a `--pretty` flag to return only the most important information.

- `docker service scale`
Lets you scale the number of replicas in a service up and down.

- `docker service update`
Lets you update many of the properties of a running service.

- `docker service logs`
Lets you view the logs of a service.

- `docker service rm`
The command to delete a service from the swarm.
Use with caution...
it deletes all service replicas without asking for confirmation.
