## nginx-echo-server

A simple openresty based image which acts as a catch-all server and echos back the request. A very poor man's version of [httpbin](https://httpbin.org).

### Features

* HTTP and HTTPS using self signed certificates
* Echoes both request headers and body
* Accepts any URL and HTTP method

### API

* `/status/{httpStatus}` - Responds with the given HTTP status
* `/jwt` - Expects a JWT token as the body and returns the decoded token (Requires the `JWT_SECRET` environment variable to be set)
* `/websocket` - WebSocket which echos the received payload. Responds to `ping` with `pong`.
* `/any/path/here` - Matches any other path and simply echoes back the request headers and body

### Usage

##### Start server

```
docker run -p 8080:80 -p 8443:443 checksum/nginx-echo-server
```

##### HTTPie

```
http --verify=no https://localhost:8443/api foo=bar "X-Custom-Header: nginx-is-awesome"
```

##### Curl

```
curl -X POST --insecure -i https://localhost:8443/api -H "Content-Type: application/json" -d '{"foo": "bar"}'
```

##### Response

```
HTTP/1.1 200 OK
Connection: keep-alive
Content-Type: application/json
Date: Mon, 13 May 2019 00:49:45 GMT
Transfer-Encoding: chunked
accept: application/json, */*
accept-encoding: gzip, deflate
host: localhost:8443
user-agent: HTTPie/0.9.9
x-custom-header: nginx-is-awesome

{
    "foo": "bar"
}
```
