/*
	A "hello world" plugin in Go,
	which reads a request header and sets a response header.
*/

package main

import (
	"fmt"
	"log"

	"github.com/Kong/go-pdk"
	"github.com/Kong/go-pdk/server"
)

func main() {
	server.StartServer(New, Version, Priority)
}

var Version = "0.2"
var Priority = 2

type Config struct {
	Message string
}

func New() interface{} {
	return &Config{}
}

func (conf Config) Access(kong *pdk.PDK) {
	kong.Log.Info("This is an example-plugin")
	host, err := kong.Request.GetHeader("host")
	if err != nil {
		log.Printf("Error reading 'host' header: %s", err.Error())
	}

	message := conf.Message
	if message == "" {
		message = "What's up"
	}
	kong.Response.SetHeader("x-hello-from-example-plugin", fmt.Sprintf("Go says %s to %s", message, host))
}

func (conf Config) Certificate(kong *pdk.PDK) {
	kong.Log.Info("This is an example-plugin")
	host, err := kong.Request.GetHeader("host")
	if err != nil {
		log.Printf("Error reading 'host' header: %s", err.Error())
	}

	message := conf.Message
	if message == "" {
		message = "What's up"
	}
	kong.Response.SetHeader("x-hello-from-example-plugin", fmt.Sprintf("Go says %s to %s", message, host))
}
