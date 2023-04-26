#!/usr/bin/env bash

set -e -o pipefail

go_version=$(curl -s https://raw.githubusercontent.com/actions/go-versions/main/versions-manifest.json | grep -oE '"version": "[0-9]{1}.[0-9]{1,}(.[0-9]{1,})?"' | head -1 | cut -d':' -f2 | sed 's/ //g; s/"//g')
curl -Lo go.tar.gz "https://go.dev/dl/go$go_version.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
export PATH="$PATH:/usr/local/go/bin"

HEAD=$(git ls-remote https://github.com/SagerNet/sing-box.git HEAD | awk '{ print $1 }')
COMMIT=${HEAD:0:7}

CGO_ENABLED=1 \
GOOS=linux \
GOARCH=amd64 \
GOAMD64=v2 \
GOBIN=/tmp/ \
go install -v -tags with_gprc,with_utls,with_reality_server github.com/sagernet/sing-box/cmd/sing-box@dev-next
cp /tmp/sing-box /opt/sing/sing-box-$COMMIT
