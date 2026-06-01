#!/usr/bin/env zsh
# ---------------------------------------------------------------------------
# start.sh – start the Spotify Automation stack with Podman
# Usage:  ./start.sh          (start)
#         ./start.sh stop     (stop & remove containers)
#         ./start.sh logs     (follow logs for both containers)
#         ./start.sh build    (rebuild images then start)
# ---------------------------------------------------------------------------

set -euo pipefail

# Load .env if present
if [[ -f .env ]]; then
  set -o allexport
  source .env
  set +o allexport
fi

SPOTIFY_CLIENT_ID="${SPOTIFY_CLIENT_ID:?Please set SPOTIFY_CLIENT_ID in .env}"
SPOTIFY_CLIENT_SECRET="${SPOTIFY_CLIENT_SECRET:?Please set SPOTIFY_CLIENT_SECRET in .env}"
APP_BACKEND_URL="${APP_BACKEND_URL:-http://127.0.0.1:8080}"
APP_FRONTEND_URL="${APP_FRONTEND_URL:-http://127.0.0.1:3000}"

BACKEND_IMAGE="localhost/spotify-backend:latest"
FRONTEND_IMAGE="localhost/spotify-frontend:latest"
NETWORK="spotify-net"

stop() {
  echo "==> Stopping containers..."
  podman rm -f spotify-backend spotify-frontend 2>/dev/null || true
  echo "Done."
}

build() {
  echo "==> Building backend image..."
  podman build --platform linux/amd64 -t "$BACKEND_IMAGE" ./backend

  echo "==> Building frontend image..."
  podman build --platform linux/amd64 \
    --build-arg "REACT_APP_API_BASE_URL=${APP_BACKEND_URL}" \
    -t "$FRONTEND_IMAGE" ./frontend
}

start() {
  # Ensure network exists
  podman network create "$NETWORK" 2>/dev/null || true

  # Remove stale containers
  podman rm -f spotify-backend spotify-frontend 2>/dev/null || true

  echo "==> Starting backend..."
  podman run -d \
    --name spotify-backend \
    --network "$NETWORK" \
    -p 8080:8080 \
    -e SPOTIFY_CLIENT_ID="$SPOTIFY_CLIENT_ID" \
    -e SPOTIFY_CLIENT_SECRET="$SPOTIFY_CLIENT_SECRET" \
    -e APP_BACKEND_URL="$APP_BACKEND_URL" \
    -e APP_FRONTEND_URL="$APP_FRONTEND_URL" \
    -v h2-data:/app/data \
    --restart unless-stopped \
    "$BACKEND_IMAGE"

  echo "==> Waiting for backend to be healthy..."
  for i in $(seq 1 20); do
    if podman exec spotify-backend wget -qO- http://localhost:8080/api/auth/me &>/dev/null; then
      echo "Backend is up."
      break
    fi
    # 401 also means Spring Boot is up (just not authenticated)
    STATUS=$(podman exec spotify-backend wget -S -qO- http://localhost:8080/api/auth/me 2>&1 | grep "HTTP/" | awk '{print $2}')
    if [[ "$STATUS" == "401" || "$STATUS" == "200" ]]; then
      echo "Backend is up (HTTP $STATUS)."
      break
    fi
    echo "  waiting... ($i/20)"
    sleep 3
  done

  echo "==> Starting frontend..."
  podman run -d \
    --name spotify-frontend \
    --network "$NETWORK" \
    -p 3000:3000 \
    --restart unless-stopped \
    "$FRONTEND_IMAGE"

  echo ""
  echo "✅  Stack is running:"
  podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep spotify
  echo ""
  echo "   Frontend: http://127.0.0.1:3000"
  echo "   Backend:  http://127.0.0.1:8080"
}

logs() {
  podman logs -f spotify-backend &
  podman logs -f spotify-frontend &
  wait
}

case "${1:-start}" in
  stop)   stop ;;
  build)  build; start ;;
  logs)   logs ;;
  start)  start ;;
  *)      echo "Usage: $0 [start|stop|build|logs]"; exit 1 ;;
esac
