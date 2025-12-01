.PHONY: up down sh logs console build

up:
	docker compose up --build

down:
	docker compose down

sh:
	docker compose exec web bash

console:
	docker compose exec web bin/rails console

logs:
	docker compose logs -f web

build:
	docker compose build
