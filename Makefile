include Makefile.vars

default: check build push

build: build_reddit build_monitoring

build_reddit: build_comment build_post build_ui

build_monitoring: build_prometheus build_mongodb_exporter build_alertmanager build_telegraf

check:
ifndef USER_NAME
	@echo Warning: Docker Hub Username isn\'t defined\; continue? [Y/n]
	@read line; if [ $$line == "n" ]; then echo Define Username in Makefile.vars; exit 1 ; fi
endif

build_comment:
	@echo -e "\e[1;31;32m Building comment image \e[0m";
	@cd src/comment && ./docker_build.sh

build_post:
	@echo -e "\e[1;31;32m Building post-py image \e[0m";
	@cd src/post-py && ./docker_build.sh

build_ui:
	@echo -e "\e[1;31;32m Building ui image \e[0m";
	@cd src/ui && ./docker_build.sh

build_prometheus:
	@echo -e "\e[1;31;32m Building prometheus image \e[0m";
	@cd monitoring/prometheus && docker build -t $(USER_NAME)/prometheus .

build_mongodb_exporter:
	@echo -e "\e[1;31;32m Building mongodb-exporter image \e[0m";
	@cd monitoring/percona-mongodb-exporter && docker build -t $(USER_NAME)/percona-mongodb-exporter .

build_alertmanager:
	@echo -e "\e[1;31;32m Building alertmanager image \e[0m";
	@cd monitoring/alertmanager && docker build -t $(USER_NAME)/alertmanager .

build_telegraf:
	@echo -e "\e[1;31;32m Building telegraf image \e[0m";
	@cd monitoring/telegraf && docker build -t $(USER_NAME)/telegraf .

push:
	@echo -e "\e[1;31;32m Pushing images to Hub \e[0m";
	@echo Input your password for Docker Hub:
	@docker login --username $(USER_NAME)
	@docker push $(USER_NAME)/comment
	@docker push $(USER_NAME)/post
	@docker push $(USER_NAME)/ui
	@docker push $(USER_NAME)/prometheus
	@docker push $(USER_NAME)/percona-mongodb-exporter
	@docker push $(USER_NAME)/alertmanager
	@docker push $(USER_NAME)/telegraf
