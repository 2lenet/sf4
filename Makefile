install:
	docker-compose build
	docker-compose up -d
	docker-compose exec symfony composer install
	docker-compose exec symfony npm install
	docker-compose exec symfony make migrate

start: ## Start the project
	cp .env.dist .env
	docker-compose up -d
	#docker-compose exec symfony composer install
	#docker-compose exec symfony make migrate
	@echo "started on http://127.0.0.1:8100/"
	@echo "PMA on http://127.0.0.1:8101/"

stop:
	docker-compose down --remove-orphans

cc:
	docker-compose exec symfony bin/console cache:clear

console:
	docker-compose exec symfony bash

migrate:
	if [[ $(id -u) -ne 0 ]] ; then echo "Please run in make console" ; exit 1 ; fi
	bin/console doc:schem:up --force
	#bin/console doc:mi:mi -n

db:
	if [[ $(id -u) -ne 0 ]] ; then echo "Please run in make console" ; exit 1 ; fi
	bin/console doc:data:create --if-not-exists
	bin/console doc:schem:up --force
	bin/console doc:fixtures:load -n

build:
	docker build -t registry.2le.net/2le/nath-tickets .
	docker push registry.2le.net/2le/nath-tickets

test:
	if [[ $(id -u) -ne 0 ]] ; then echo "Please run in make console" ; exit 1 ; fi
	cp phpunit.xml.dist phpunit.xml
	bin/console doc:schem:up --force
	# bin/console doctrine:migrations:migrate -n
	bin/phpunit tests/ -v --coverage-clover phpunit.coverage.xml --log-junit phpunit.report.xml

wp-watch: #WebPack Encore Watch
	# if [[ $(id -u) -ne 0 ]] ; then echo "Please run in make console" ; exit 1 ; fi
	docker-compose exec symfony ./node_modules/.bin/encore dev --watch


.PHONY: all test run init cc test
