package main

import (
	"context"
	"log"
	"net/http"

	"github.com/bufbuild/connect-go"
	pingpb "github.com/kk-no/exp-connect/gen/proto/ping/v1"
	pingcpb "github.com/kk-no/exp-connect/gen/proto/ping/v1/pingv1connect"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

func main() {
	path, handler := pingcpb.NewPingServiceHandler(NewServer())

	mux := http.NewServeMux()
	mux.Handle(path, handler)

	log.Fatal(http.ListenAndServe(":8080", h2c.NewHandler(mux, &http2.Server{})))
}

var _ pingcpb.PingServiceHandler = (*Server)(nil)

type Server struct {
	pingcpb.UnimplementedPingServiceHandler
}

func NewServer() *Server {
	return &Server{}
}

func (s *Server) Ping(ctx context.Context, r *connect.Request[pingpb.PingRequest]) (*connect.Response[pingpb.PingResponse], error) {
	log.Println("Receive ping request")
	return connect.NewResponse(&pingpb.PingResponse{}), nil
}
