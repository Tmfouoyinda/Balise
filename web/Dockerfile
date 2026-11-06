# Dev image only. Production serves the static build from Caddy.
# Build context is the monorepo root (see compose.yml).
FROM node:24.22.1-bookworm-slim

# npm workspaces resolve from the monorepo root
WORKDIR /app
RUN chown node:node /app
USER node

# Manifests first: the npm ci layer stays cached until dependencies change.
# api/package.json is needed because the root lockfile references both workspaces.
COPY --chown=node:node package.json package-lock.json ./
COPY --chown=node:node api/package.json api/
COPY --chown=node:node web/package.json web/
RUN npm ci -w web
# Workspaces hoist dependencies to /app/node_modules, so web/node_modules may not exist.
# Create it as node: otherwise Docker creates the volume mount point as root
# and Vite cannot write its cache (node_modules/.vite).
RUN mkdir -p web/node_modules

# In dev, compose bind-mounts ./web over this copy for hot reload
COPY --chown=node:node web/ web/

EXPOSE 5173

CMD ["npm", "run", "dev", "-w", "web"]
