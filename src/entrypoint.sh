#!/usr/bin/env bash
set -euo pipefail

# Optional Tailscale bootstrap for Railway containers.
# Keeps OpenClaw startup resilient: if Tailscale fails, gateway still starts.
if [ -n "${TAILSCALE_AUTH_KEY:-}" ]; then
  echo "[entrypoint] TAILSCALE_AUTH_KEY detected, starting tailscaled..."
  mkdir -p /var/run/tailscale /data/.tailscale

  if ! pgrep -x tailscaled >/dev/null 2>&1; then
    tailscaled \
      --state=/data/.tailscale/tailscaled.state \
      --socket=/var/run/tailscale/tailscaled.sock \
      --tun=userspace-networking \
      >/tmp/tailscaled.log 2>&1 &
    sleep 2
  fi

  if tailscale up \
      --auth-key="${TAILSCALE_AUTH_KEY}" \
      --hostname="${TAILSCALE_HOSTNAME:-adosi-railway}" \
      --accept-routes=false \
      --reset; then
    echo "[entrypoint] tailscale up: OK"
    tailscale status || true
  else
    echo "[entrypoint] WARNING: tailscale up failed; continuing without tailnet"
    cat /tmp/tailscaled.log 2>/dev/null || true
  fi
fi

exec node src/server.js
