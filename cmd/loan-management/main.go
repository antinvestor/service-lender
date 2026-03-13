package main

import (
	"log"
	"net/http"
	"github.com/pitabwire/frame"
	"github.com/antinvestor/service-ant-lender/apps/loan-management/service"
)

func main() {
	mux := http.NewServeMux()
	service.RegisterRoutes(mux)

	ctx, svc := frame.NewService(
		frame.WithName("loan-management"),
		frame.WithHTTPHandler(mux),
	)
	if err := svc.Run(ctx, ":8080"); err != nil {
		log.Fatal(err)
	}
}
