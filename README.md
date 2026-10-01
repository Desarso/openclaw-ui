# openclaw-ui

A deployment wrapper that serves the [OpenClaw](https://github.com/openclaw/openclaw) Control web UI and proxies its WebSocket traffic to an OpenClaw gateway, all from one container. I made it to host the Control UI on Coolify, separately from the machine that runs the gateway.

## How it works

```
browser ──HTTP──▶ Caddy :80 ──▶ /srv/ui (static, SPA fallback to index.html)
        ──WS────▶ Caddy :80 ──▶ $GATEWAY_URL (OpenClaw gateway, port 18789 by default)
```

- `ui/` is a prebuilt copy of the upstream OpenClaw Control UI (a Lit web-component app, `<openclaw-app>`). It's committed as built assets with a source map, not as source.
- `Caddyfile` sends requests that carry `Connection: Upgrade` / `Upgrade: websocket` to the gateway and serves everything else as static files. It also adds `X-Frame-Options: DENY`, `nosniff` and a referrer policy, and gzips responses.
- `Dockerfile` copies both into `caddy:2-alpine` and exposes port 80.

## Run

```bash
docker build -t openclaw-ui .
docker run --rm -p 8080:80 -e GATEWAY_URL=http://<gateway-host>:18789 openclaw-ui
```

## Configuration

- `GATEWAY_URL`: the upstream OpenClaw gateway that WebSocket connections are proxied to. Set it explicitly. The default in the `Caddyfile` only works on the author's LAN.

## Status

This was a one-commit deployment experiment, and the bundled UI is a snapshot from February 2026. To update it, rebuild the Control UI from upstream OpenClaw and replace `ui/`.

The UI code belongs to the OpenClaw project, which is MIT-licensed. This repo adds only the Caddy and Docker wrapper.
