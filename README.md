# Docker Swarm Participation Key Sidecar Monitoring

This simple Dockerfile and script are used for monitoring
participation keys in a Docker Swarm cluster.

The script check for online transaction registration expiration key
and if it is about to expire it will invoke a service via the Docker Swarm
managed service 'notify' (defined in the notification.yml file)
