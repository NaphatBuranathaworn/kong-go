# Build Plugins
FROM golang:1.23 AS plugin-builder

WORKDIR /builder

# Copy go.work to the build context to manage multi-module workspace
COPY go.work ./go.work

# Copy plugin directories to the build context
COPY ./go_modules/my-plugin ./go_modules/my-plugin
COPY ./go_modules/example-plugin ./go_modules/example-plugin

# Run go mod tidy in each plugin directory to ensure dependencies are resolved
RUN cd ./go_modules/my-plugin && go mod tidy && go build -o /builds/my-plugin main.go
RUN cd ./go_modules/example-plugin && go mod tidy && go build -o /builds/example-plugin main.go

# Build Kong and include the built plugins
FROM kong:3.4.0-ubuntu

# Copy the built plugins into the Kong image
COPY --from=plugin-builder ./builds/ /kong/

USER kong

# Set environment variables
ENV KONG_LOG_LEVEL=info

# Add the plugins to the environment variables
ENV KONG_PLUGINS="bundled,my-plugin,example-plugin"
ENV KONG_PLUGINSERVER_NAMES="my-plugin,example-plugin"

ENV KONG_PLUGINSERVER_MY_PLUGIN_START_CMD="/kong/my-plugin"
ENV KONG_PLUGINSERVER_MY_PLUGIN_QUERY_CMD="/kong/my-plugin -dump"

ENV KONG_PLUGINSERVER_EXAMPLE_PLUGIN_START_CMD="/kong/example-plugin"
ENV KONG_PLUGINSERVER_EXAMPLE_PLUGIN_QUERY_CMD="/kong/example-plugin -dump"
