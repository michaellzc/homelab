#!/bin/bash

set -euo pipefail

export TS_API_CLIENT_ID="$(op read "op://Private/yi2bu5dp4jjuadqbjf7dqv7pwu/get_authkey_oauth_client/client_id")"
export TS_API_CLIENT_SECRET="$(op read "op://Private/yi2bu5dp4jjuadqbjf7dqv7pwu/get_authkey_oauth_client/client_secret")"

go run tailscale.com/cmd/get-authkey@latest -preauth -tags tag:lab-vm -ephemeral
