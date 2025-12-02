# PokeBinder — Backend (Rails)

**Quickstart (development, Docker)**

```bash
git clone <repo-url>
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