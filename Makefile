.DEFAULT_GOAL := help

ACCENT  := $(shell tput -Txterm setaf 2)
RESET := $(shell tput init)
NETWORK_INNER := $(shell docker network ls |grep skaben 1>&2 2> /dev/null; echo $$?)

network-create:
	@if [ $(NETWORK_INNER) -ne 0 ]; then\
		docker network create skaben_network;\
	fi

build: ##  Собрать с использованием кэша
	@docker-compose build

build-clean: ##  Собрать без кэша
	@docker-compose down -v
	@docker-compose build --no-cache

start: network-create  ##  Запуск
	@docker-compose up -d

stop:  ##  Останов
	@docker-compose down

restart: ##  Перезапустить
	@docker-compose up --force-recreate -d

info:  ##  Показать список сервисов
	@docker-compose ps -a

shell: ##  Интерактивная оболочка
	@docker-compose exec rabbitmq bash

help:
	@echo "\nКоманды:\n"
	@grep -E '^[a-zA-Z.%_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%2s$(ACCENT)%-20s${RESET} %s\n", " ", $$1, $$2}'
	@echo ""
