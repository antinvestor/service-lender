package main

import (
	"log"
	"net/http"
	"github.com/pitabwire/frame"
	"github.com/antinvestor/service-ant-lender/apps/origination/service"
)

func main() {
	mux := http.NewServeMux()
	service.RegisterRoutes(mux)
	ctx, svc := frame.NewService(
		frame.WithName("origination"),
		frame.WithHTTPHandler(mux),
	)
	if err := svc.Run(ctx, ":8080"); err != nil {
		log.Fatal(err)
	}
}
