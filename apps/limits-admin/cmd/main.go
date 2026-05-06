// Copyright 2023-2026 Ant Investor Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"fmt"
	"net/http"
	"os"

	"buf.build/gen/go/antinvestor/limits/connectrpc/go/limits/v1/limitsv1connect"
	"connectrpc.com/connect"
	"github.com/spf13/cobra"
)

var (
	flagURI      string
	flagInsecure bool
	flagJSON     bool
)

func main() {
	root := &cobra.Command{
		Use:   "limits-admin",
		Short: "Operator CLI for the limits service",
		Long: `limits-admin wraps the LimitsAdminService Connect endpoints with
tabwriter or JSON output. Use --uri to point at the limits service and
--insecure for local/staging environments that skip SPIFFE auth.`,
		SilenceUsage: true,
	}

	root.PersistentFlags().StringVar(&flagURI, "uri", "https://limits.internal", "Base URL of the limits service")
	root.PersistentFlags().BoolVar(&flagInsecure, "insecure", false, "Skip TLS verification (local/staging only)")
	root.PersistentFlags().BoolVar(&flagJSON, "json", false, "Emit JSON instead of tabwriter plaintext")

	root.AddCommand(policiesCmd())
	root.AddCommand(reservationsCmd())
	root.AddCommand(approvalsCmd())

	if err := root.Execute(); err != nil {
		os.Exit(1)
	}
}

// newAdminClient constructs a LimitsAdminServiceClient from the top-level flags.
// When --insecure is set it uses a plain http.Client without TLS verification.
func newAdminClient() limitsv1connect.LimitsAdminServiceClient {
	httpClient := http.DefaultClient
	opts := []connect.ClientOption{}
	if flagInsecure {
		opts = append(opts, connect.WithGRPC())
	}
	return limitsv1connect.NewLimitsAdminServiceClient(httpClient, flagURI, opts...)
}

// die prints msg to stderr and exits 1.
func die(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "error: "+format+"\n", args...)
	os.Exit(1)
}
