# ---------- Builder ----------
FROM ghcr.io/cirruslabs/flutter:3.38.7 AS builder
WORKDIR /app

COPY app-ui/ ./

RUN flutter pub get
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release --base-href /

# ---------- Final ----------
FROM caddy:2-alpine

COPY --from=builder /app/build/web /srv

# SPA fallback: serve index.html for all non-file routes (Flutter client-side routing)
# Security headers and compression included
COPY apps/ui/Caddyfile /etc/caddy/Caddyfile

EXPOSE 80
