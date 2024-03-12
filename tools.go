//go:build tools

package main

// the tools.go + Makefile pattern installs local go tools
// https://marcofranssen.nl/manage-go-tools-via-go-modules

import (
	_ "github.com/fairwindsops/pluto/v5/cmd/pluto"
	_ "github.com/go-task/task/v3/cmd/task"
	_ "github.com/helmfile/helmfile"
	_ "github.com/int128/kubelogin"
	_ "github.com/liatrio/k8s-platform-v3-monorepo/tooling/argo-app-profiler"
	_ "github.com/mikefarah/yq/v4"
	_ "github.com/open-policy-agent/conftest"
	_ "github.com/open-policy-agent/opa"
	_ "gotest.tools/gotestsum"
	_ "helm.sh/helm/v3/cmd/helm"
	_ "sigs.k8s.io/kustomize/kustomize/v5"
)
