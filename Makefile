IAM_ROLE := "arn:aws:iam::471112665254:role/local-testing-read-only"
AWS_REGION := us-east-1
SESSION_NAME := k8s-platform-v3-test-suite

OIDC_ISSUER := https://auth.mgmt.k8s-platform-v3.liatr.io/dex
OIDC_CLIENT_ID := aws
OIDC_EXTRA_SCOPES := "openid,profile"

# Install & Build
install-tools: download bin
	@echo Installing tools from tools.go
	@cat tools.go | grep _ | awk -F'"' '{print $$2}' | GOBIN=$$(pwd)/bin xargs -tI % go install %

bin:
	mkdir -p bin
download:
	@echo Download go.mod dependencies
	@go mod download

# Tidy
tidy:
	go mod tidy

./bin/kubelogin: install-tools

aws-auth: bin/kubelogin
	ID_TOKEN=$$(./bin/kubelogin get-token \
		--oidc-issuer-url=$(OIDC_ISSUER) \
		--oidc-client-id=$(OIDC_CLIENT_ID) \
		--oidc-extra-scope=$(OIDC_EXTRA_SCOPES) | jq -r .status.token); \
	aws sts assume-role-with-web-identity \
		--role-arn $(IAM_ROLE) \
		--role-session-name $(SESSION_NAME) \
		--web-identity-token $$ID_TOKEN \
		--region $(AWS_REGION)

# Test
test:
	@rm -rf .localized
	./bin/kustomize localize . .localized
	KUSTOMIZE_ROOT=.localized PATH=$$(pwd)/bin:$$PATH gotestsum --format testdox --junitfile report.xml -- ./... -count=1

test-cached:
	test -d .localized || ./bin/kustomize localize . .localized
	KUSTOMIZE_ROOT=.localized PATH=$$(pwd)/bin:$$PATH gotestsum --format testdox --junitfile report.xml -- ./... -count=1