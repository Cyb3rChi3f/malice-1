module github.com/maliceio/malice

go 1.21

require (
	github.com/BurntSushi/toml v1.3.2
	github.com/containerd/containerd v1.7.22 // Constrain to version compatible with Go 1.22
	github.com/docker/docker v17.12.0-ce-rc1.0.20200916142827-bd33bbf0497b+incompatible
	github.com/docker/go-connections v0.4.0
	github.com/dustin/go-jsonpointer v0.0.0-20160814072949-ba0abeacc3dc
	github.com/fatih/structs v1.1.0
	github.com/fsnotify/fsnotify v1.7.0
	github.com/gorilla/mux v1.8.1
	github.com/malice-plugins/pkgs v1.1.7
	github.com/olekukonko/tablewriter v0.0.5
	github.com/opencontainers/runc v1.1.12 // Constrain to version compatible with Go 1.21
	github.com/parnurzeal/gorequest v0.2.16
	github.com/pkg/errors v0.9.1
	github.com/sirupsen/logrus v1.9.3
	github.com/spf13/cobra v1.8.0
	github.com/spf13/viper v1.18.2
	github.com/urfave/cli v1.22.14
	gopkg.in/natefinch/lumberjack.v2 v2.2.1
)

// Exclude problematic versions that require newer Go versions
exclude (
	github.com/opencontainers/runc v1.4.0
	github.com/containerd/containerd v1.7.23
	github.com/containerd/containerd v1.7.24
	github.com/containerd/containerd v1.7.25
	github.com/containerd/containerd v1.7.26
	github.com/containerd/containerd v1.7.27
	github.com/containerd/containerd v1.7.28
	github.com/containerd/containerd v1.7.29
)

// Replace directives to use compatible Docker library version
// The old v17.12.0 has packages that have been moved in newer versions
replace (
	github.com/docker/docker => github.com/docker/docker v20.10.27+incompatible
)
