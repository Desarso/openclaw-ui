# OpenClaw UI with Gateway Proxy
FROM caddy:2-alpine

# Copy pre-built UI files
COPY ui /srv/ui

# Copy Caddy config
COPY Caddyfile /etc/caddy/Caddyfile

# Expose port
EXPOSE 80
