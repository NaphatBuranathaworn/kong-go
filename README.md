
1. Set up directory

https://docs.konghq.com/gateway/latest/plugin-development/get-started/setup/

2. Understand file structure

https://docs.konghq.com/gateway/latest/plugin-development/file-structure/


3. Init go plugin


docker compose up -d && docker logs gateway_kong -f

docker compose build && docker compose down && docker compose up -d && docker logs gateway_kong -f


https://medium.com/@sripusponegoro/create-kong-custom-plugin-golang-354ce0e0ebf0
https://dev.to/mfbmina/writing-kong-plugins-with-go-1h12



1. test upstream service
curl -i -X POST 'http://localhost:9090/api/getCustomerInfo'

2. create service
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

2. create route
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



curl -i -X POST 'http://localhost:9000/api/getCustomerInfo'


curl -i -X POST 'http://localhost:8001/plugins/services' \
--header 'Content-Type: application/json' \
--data '{
  "name": "my-plugin",
  "config": {
    "message": "World"
  }
}'


curl -i -X POST 'http://localhost:8001/plugins' \
--header 'Content-Type: application/json' \
--data '{
  "name": "example-plugin",
  "config": {
    "message": "World Ja"
  }
}'

curl -i -X POST 'http://localhost:8001/plugins' \
--header 'Content-Type: application/json' \
--data '{
  "name": "example-plugin",
  "config": {
    "message": "World Ja"
  }
}'



Usecase 
1. จาก plugin ที่มีลอง get api path แล้วเทียบกับ config เช่น
confg.api_path = /getCustomer

้ถ้าส่ง /customer จะ return error message ตามที่กำหนด


2. ลองทำ plugin ip-whitelist ด้วยตัวเอง

3. ลอง query ของใน db ของ kong เอง
-- Core DAOs
local services  = kong.db.services
local routes    = kong.db.routes
local consumers = kong.db.consumers
local plugins   = kong.db.plugins



