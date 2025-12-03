# PokeBinder — Backend (Rails)

**Quickstart (development, Docker)**

```bash
git clone https://github.com/daffa-pradana/pokebinder-backend.git
cd pokebinder-backend
# copy .env.example -> .env and edit if needed
make up
make bash   # to get a shell inside the running web container
make db     # create & migrate DB inside the container
# open http://localhost:3000
```

**Helpful make targets**

- `make up` — start services (build images if needed)
- `make down` — stop containers
- `make bash` — open a shell in the `web` container
- `make logs` — stream logs
- `make db` — run `rails db:create db:migrate` inside container

**ENV file example**

`.env.example`
```env
# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_DB=pokebinder_development
DATABASE_URL=postgres://postgres:password@db:5432/pokebinder_development

# Redis
REDIS_URL=redis://redis:6379/0

# Rails
RAILS_ENV=development

# Secrets (copy master.key to config/master.key or fill values for production)
# RAILS_MASTER_KEY=
```