# Androgee

Androgee is multi-purpose microservice oriented application built for the Egee.io community to do a myriad of things.

## Microservices

Each subfolder represents an atomic service or ability that Androgee can do. The services themselves standalone and do not depend on one another. Intra-microservice communication is facilitated via messaging, currently Redis Pub/Sub.

#### Current Microservices:

* **Discord** - A Discord bot
* **Wrcon** - A general purpose service to communicate with game servers via (w)Rcon protocol