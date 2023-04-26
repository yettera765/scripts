#!/usr/bin/env bash

set -e -o pipefail

if [ -d /usr/local/go ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi

HEAD=$(git ls-remote https://github.com/SagerNet/sing-box.git HEAD | awk '{ print $1 }')
COMMIT=${HEAD:0:7}

CGO_ENABLED=1 \
GOOS=linux \
GOARCH=amd64 \
GOAMD64=v2 \
GOBIN=/tmp/ \
go install -v -tags with_gprc,with_utls,with_reality_server github.com/sagernet/sing-box/cmd/sing-box@dev-next
cp /tmp/sing-box /opt/sing/sing-box-$COMMIT
