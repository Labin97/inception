all: prep
	@docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@docker compose -f ./srcs/docker-compose.yml down

re: clean prep
	@docker compose -f srcs/docker-compose.yml up -d --build

clean:
	@if [ -n "$$(docker ps -qa)" ]; then \
		docker stop $$(docker ps -qa); \
		docker rm $$(docker ps -qa); \
	fi
	@if [ -n "$$(docker images -qa)" ]; then \
		docker rmi -f $$(docker images -qa); \
	fi
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi
	@docker network ls | tail -n +2 | awk '$$2 !~ /bridge|none|host/' | awk '{ print $$1 }' | xargs -r -I {} docker network rm {}
	sudo rm -rf /home/yim/data

prep:
	@if [ ! -d "/home/$$USER/data/wordpress" ]; then \
		mkdir -p /home/$$USER/data/wordpress; \
	fi
	@if [ ! -d "/home/$$USER/data/mysql" ]; then \
		mkdir -p /home/$$USER/data/mysql; \
	fi

3:
	docker rm -f $(shell docker ps -aq) || echo a
	docker rmi -f $(shell docker images -q) || echo a
	docker volume rm $(shell docker volume ls -q) || echo a

.PHONY: all re down clean prep
