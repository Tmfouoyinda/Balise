# Balise

Cockpit CRA en français pour les petits fabricants de logiciels, d'apps mobiles et d'objets connectés : inventaire, veille sur SBOM, signalements CVD et chrono des échéances de l'article 14.

Balise est un outil d'aide. Ce n'est pas un conseil juridique.

## Structure

- `api/` : NestJS (API, worker, scheduler)
- `web/` : SPA React + Vite

Monorepo npm workspaces, un seul `package-lock.json` à la racine.

## Démarrer

```sh
npm install
npm run dev:api
npm run dev:web
```

Node 22 ou plus (voir `.nvmrc`).
