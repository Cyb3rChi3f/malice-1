module github.com/maliceio/malice

go 1.24.3

require (
	github.com/BurntSushi/toml v1.5.0
	github.com/cloudflare/cfssl v1.6.5
	github.com/containerd/containerd v1.7.22 // Constrain to version compatible with Go 1.22
	github.com/docker/cli v20.10.27+incompatible
	github.com/docker/distribution v2.8.2+incompatible
	github.com/docker/docker v27.3.1+incompatible
	github.com/docker/go-connections v0.5.0
	github.com/docker/go-units v0.5.0
	github.com/docker/machine v0.16.2
	github.com/dustin/go-jsonpointer v0.0.0-20160814072949-ba0abeacc3dc
	github.com/fatih/structs v1.1.0
	github.com/fsnotify/fsnotify v1.9.0
	github.com/gorilla/mux v1.8.1
	github.com/jordan-wright/email v4.0.1-0.20210109023952-943e75fe5223+incompatible
	github.com/malice-plugins/pkgs v1.1.7
	github.com/olekukonko/tablewriter v0.0.5
	github.com/opencontainers/runc v1.1.12 // Constrain to version compatible with Go 1.21
	github.com/parnurzeal/gorequest v0.2.16
	github.com/pkg/errors v0.9.1
	github.com/sirupsen/logrus v1.9.3
	github.com/spf13/cobra v1.8.0
	github.com/spf13/viper v1.18.2
	github.com/urfave/cli v1.22.17
	gopkg.in/natefinch/lumberjack.v2 v2.2.1
)

require github.com/moby/buildkit v0.11.0-rc1

require (
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/cenkalti/backoff/v5 v5.0.3 // indirect
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/containerd/continuity v0.4.5 // indirect
	github.com/containerd/errdefs v1.0.0 // indirect
	github.com/containerd/errdefs/pkg v0.3.0 // indirect
	github.com/containerd/log v0.1.0 // indirect
	github.com/cpuguy83/go-md2man/v2 v2.0.7 // indirect
	github.com/distribution/reference v0.6.0 // indirect
	github.com/docker/docker-credential-helpers v0.9.3 // indirect
	github.com/docker/go v1.5.1-1.0.20160303222718-d30aec9fd63c // indirect
	github.com/docker/go-metrics v0.0.1 // indirect
	github.com/dustin/gojson v0.0.0-20160307161227-2e71ec9dd5ad // indirect
	github.com/felixge/httpsnoop v1.0.4 // indirect
	github.com/fvbommel/sortorder v1.1.0 // indirect
	github.com/go-logr/logr v1.4.3 // indirect
	github.com/go-logr/stdr v1.2.2 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.27.2 // indirect
	github.com/klauspost/compress v1.18.1 // indirect
	github.com/mailru/easyjson v0.7.1 // indirect
	github.com/mattn/go-runewidth v0.0.9 // indirect
	github.com/moby/docker-image-spec v1.3.1 // indirect
	github.com/moby/go-archive v0.1.0 // indirect
	github.com/moby/patternmatcher v0.6.0 // indirect
	github.com/moby/sys/atomicwriter v0.1.0 // indirect
	github.com/moby/sys/sequential v0.6.0 // indirect
	github.com/moby/sys/symlink v0.2.0 // indirect
	github.com/moby/sys/user v0.4.0 // indirect
	github.com/moby/sys/userns v0.1.0 // indirect
	github.com/moby/term v0.5.2 // indirect
	github.com/morikuni/aec v1.0.0 // indirect
	github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822 // indirect
	github.com/olivere/elastic/v7 v7.0.12 // indirect
	github.com/opencontainers/go-digest v1.0.0 // indirect
	github.com/opencontainers/image-spec v1.1.1 // indirect
	github.com/prometheus/client_golang v1.23.2 // indirect
	github.com/prometheus/client_model v0.6.2 // indirect
	github.com/prometheus/common v0.66.1 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	github.com/samalba/dockerclient v0.0.0-20160531175551-a30362618471 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	github.com/theupdateframework/notary v0.7.0 // indirect
	go.opentelemetry.io/auto/sdk v1.2.1 // indirect
	go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp v0.61.0 // indirect
	go.opentelemetry.io/otel v1.38.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/otlpmetric/otlpmetricgrpc v1.38.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/otlptrace v1.38.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc v1.38.0 // indirect
	go.opentelemetry.io/otel/metric v1.38.0 // indirect
	go.opentelemetry.io/otel/sdk v1.38.0 // indirect
	go.opentelemetry.io/otel/sdk/metric v1.38.0 // indirect
	go.opentelemetry.io/otel/trace v1.38.0 // indirect
	go.opentelemetry.io/proto/otlp v1.7.1 // indirect
	go.yaml.in/yaml/v2 v2.4.2 // indirect
	golang.org/x/crypto v0.42.0 // indirect
	golang.org/x/net v0.44.0 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/sys v0.37.0 // indirect
	golang.org/x/term v0.35.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	golang.org/x/time v0.14.0 // indirect
	google.golang.org/genproto/googleapis/api v0.0.0-20250825161204-c5933d9347a5 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20250825161204-c5933d9347a5 // indirect
	google.golang.org/grpc v1.76.0 // indirect
	google.golang.org/protobuf v1.36.10 // indirect
	moul.io/http2curl v1.0.0 // indirect
)

// Exclude problematic versions that require newer Go versions
exclude (
	github.com/containerd/containerd v1.7.23
	github.com/containerd/containerd v1.7.24
	github.com/containerd/containerd v1.7.25
	github.com/containerd/containerd v1.7.26
	github.com/containerd/containerd v1.7.27
	github.com/containerd/containerd v1.7.28
	github.com/containerd/containerd v1.7.29
	github.com/opencontainers/runc v1.4.0
)

// Force older Docker version that still has pkg/term for docker/machine compatibility
replace github.com/docker/docker => github.com/docker/docker v20.10.27+incompatible
