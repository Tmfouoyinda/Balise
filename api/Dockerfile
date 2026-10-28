# Dev image only. Production gets its own multi-stage Dockerfile later.
# Build context is the monorepo root (see compose.yml).
FROM node:24.22.1-bookworm-slim

# npm workspaces resolve from the monorepo root
WORKDIR /app
RUN chown node:node /app
USER node

# Manifests first: the npm ci layer stays cached until dependencies change.
# web/package.json is needed because the root lockfile references both workspaces.
COPY --chown=node:node package.json package-lock.json ./
COPY --chown=node:node api/package.json api/
COPY --chown=node:node web/package.json web/
RUN npm ci -w api

# In dev, compose bind-mounts ./api over this copy for hot reload
COPY --chown=node:node api/ api/

EXPOSE 3000

CMD ["npm", "run", "start:dev", "-w", "api"]
