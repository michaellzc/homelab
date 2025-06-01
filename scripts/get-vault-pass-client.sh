#!/bin/bash

set -euo pipefail

VAULT_ID=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --vault-id)
      VAULT_ID="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
    esac
done

if [[ -z "$VAULT_ID" ]]; then
  echo "Error: --vault-id argument is required" >&2
  exit 1
fi

op read "op://Private/HomeLab Ansible Vault Password/$VAULT_ID"
