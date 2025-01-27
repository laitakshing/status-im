.PHONY: up down dbt-build dbt-compile

up:
	docker compose up -d

down:
	dockerc compose down

dbt-build:
	docker compose run dbt build

dbt-compile:
	docker compose run dbt compile
