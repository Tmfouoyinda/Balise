# Balise

Cockpit CRA en français pour les petits fabricants de logiciels, d'apps mobiles et d'objets connectés : inventaire, veille sur SBOM, signalements CVD et chrono des échéances de l'article 14.

Balise est un outil d'aide. Ce n'est pas un conseil juridique.

## Structure

- `api/` : NestJS (API, worker, scheduler)
- `web/` : SPA React + Vite

Monorepo npm workspaces, un seul `package-lock.json` à la racine.

## Démarrer

Node 24 (voir `.nvmrc`).

```sh
npm install
npm run dev:api
npm run dev:web
```

## Environnement Docker (dev)

Première fois :

1. Copier `.env.example` en `.env` et remplir les valeurs. Pas de `@ : / ? #` dans les mots de passe : ils finissent dans des URL.
2. Copier `garage.toml.example` en `garage.toml`. Générer `rpc_secret` (`openssl rand -hex 32`), `admin_token` et `metrics_token` (`openssl rand -base64 32`). Sans ce fichier, Docker crée un dossier `garage.toml` et Garage ne démarre pas.
3. `docker compose up -d --build`
4. `bash scripts/garage-init.sh` : layout, clé et bucket `balise-dev`. Reporter la clé affichée dans `.env` (`S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY`), puis `docker compose up -d api`.

Au quotidien :

- `docker compose up -d` puis `docker compose logs -f api`.
- Après un changement de `package.json` : `docker compose up -d --build -V api` (`-V` recrée le volume `node_modules`).
- Interface Garage (image tierce) : `docker compose --profile tools up -d bucket-ui`.

Ports, tous sur 127.0.0.1 : API 3200, MySQL 3310, RabbitMQ 5672 et 15672, Garage S3 3900, admin 3903, bucket-ui 3909, Mailpit SMTP 1025 et UI 8025.
