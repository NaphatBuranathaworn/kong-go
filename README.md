
1. Set up directory

https://docs.konghq.com/gateway/latest/plugin-development/get-started/setup/

2. Understand file structure

https://docs.konghq.com/gateway/latest/plugin-development/file-structure/


3. Init go plugin



### Run command
``` bash
docker compose up -d && docker logs gateway_kong -f
```



https://medium.com/@sripusponegoro/create-kong-custom-plugin-golang-354ce0e0ebf0
https://dev.to/mfbmina/writing-kong-plugins-with-go-1h12



1. test upstream service
```bash
curl -i -X POST 'http://localhost:9090/api/getCustomerInfo'
```

2. create service
```bash
curl -i -X POST 'http://localhost:8001/services' \
--header 'Content-Type: application/json' \
--data '{
  "name": "my-service",
  "retries": 5,
  "protocol": "http",
  "host": "host.docker.internal",
  "port": 9090,
  "path": "/api/getCustomerInfo",
  "connect_timeout": 6000,
  "write_timeout": 6000,
  "read_timeout": 6000,
  "enabled": true
}'
```

2. create route
```bash
curl -i -X POST 'http://localhost:8001/services/my-service/routes' \
--header 'Content-Type: application/json' \
--data '{
  "name": "my-route",
  "protocols": [
    "http",
    "https"
  ],
  "methods": [
    "POST"
  ],
  "paths": [
    "/api/getCustomerInfo"
  ],
  "https_redirect_status_code": 426,
  "regex_priority": 0,
  "strip_path": true,
  "path_handling": "v0",
  "preserve_host": false,
  "request_buffering": true,
  "response_buffering": true
}'
```

After configuration

Let's try
```sh
curl -i -X POST 'http://localhost:9000/api/getCustomerInfo'
```

### Apply Custom Plugin
```sh
curl -i -X POST 'http://localhost:8001/plugins/services' \
--header 'Content-Type: application/json' \
--data '{
  "name": "my-plugin",
  "config": {
    "message": "World"
  }
}'
```

```sh
curl -i -X POST 'http://localhost:8001/plugins' \
--header 'Content-Type: application/json' \
--data '{
  "name": "example-plugin",
  "config": {
    "message": "World Ja"
  }
}'
```


