.PHONY: up down bash logs db seed build test

up:
	docker compose up --build -d

down:
	docker compose down

bash:
	docker compose exec web bash

logs:
	docker compose logs -f web

db:
	docker compose exec web bundle exec rails db:create db:migrate

seed:
	docker compose exec web bundle exec rails db:seed

build:
	docker compose build web

test:
	docker compose exec web bundle exec rails test

reset-db:
	docker compose down -v
	docker compose up --build -d
