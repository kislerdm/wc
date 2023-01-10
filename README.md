# WebSocket Demo

The project illustrates a use case of the [websocket](https://www.rfc-editor.org/rfc/rfc6455) (ws) protocol.

## Modus Operandi

- The client app sends the request to the server;
- Upon successful handshake, the server pushes current UTC timestamp as ISO string in perpetual loop every 200 ms.;
- Client app tails the last 30 server responses.

```mermaid
sequenceDiagram
    participant web as Web Browser
    participant http as "/" endpoint
    participant ws as "/ws" endpoint
    
    web->>+http: Initial call
    http->>-web: Returns HTML page
    
    web->>+ws: Send WS message
    ws->>-web: Returns current timestamp every 200 ms. 
```

## How to run

### Prerequisites

- [Docker](https://www.docker.com/)
- [gnuMake](https://www.gnu.org/software/make/)

### Commands

- Run to see available commands:

```commandline
make help
```

- Run to start the server:

```commandline
make start
```

- Run to stop the server and clean the environment:

```commandline
make stop
```
