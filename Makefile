up:
	docker compose up --build

down:
	docker compose down

bash:
	docker compose exec web bash

logs:
	docker compose logs -f web

db:
	docker compose exec web bundle exec rails db:create db:migrate

reset-db:
	docker compose down -v
	docker compose up --build
