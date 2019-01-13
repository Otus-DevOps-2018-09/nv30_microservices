# nv30_microservices
nv30 microservices repository

## Homework-13: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=docker-2)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - Создан новый проект в GCP и он выбран по умолчанию в gcloud cli.
 - Установлен docker-machine и с помощью него создана первая машина с docker в gce.
 - Повторена практика из лекции, где наглядно показана изоляция процессов, сетей и пользователей.
 - При запуске контейнера с ключом "--pid host" с хоста видны pid'ы процессов из контейнера. Для общего развития запустил контейнер с ключами "--net=host", "--pid=host" и "--ipc=host".   
 - В корне репо создана папка docker-monolith и необходимые конфигурационные файлы.
 - Создан образ reddit с приложением reddit-app. Он запушен в docker-hub и его можно найти по имени "nv30/otus-reddit:1.0".
 - \*В папке infra созданы конфигурационные файлы для:
   - Создания образа в gce на базе ubuntu 16.04 с установленным docker ce с помощью packer. В качестве провиженера используется плейбук с коммьюнити ролью "geerlingguy.docker".
   - Создания инфраструктуры с помощью terraform в gce. Количество создаваемых машин можно указать в переменной "vm_count" в файле terraform.tfvars.
   - Запуска контейнера на созданных в gce машинах с помощью ansible. Для dynamic inventory используется gcp_compute.

## Homework-12: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=docker-1)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - Настроена интеграция репозитория nv30_microservices с Travis CI и Slack.
 - Установлен Docker CE v18.09.
 - Успешно запущен тестовый контейнер hello-world. При этом из-за его отсутствия на локальной машине, он был автоматически скачан с Docker Hub.
 - Запущены контейнеры из образа ubuntu:16.04. В первом контейнере создан файл "/tmp/file".
 - С помощью команды "docker ps -a" выяснен id созданных контейнеров. Командой "docker start <u_container_id>" запущен контейнер, где был создан файл. Командой "docker attach <u_container_id>" произведено подключение к запущенному контейнеру и проверка, что созданный файл на месте.
 - Изучена разница между командами "docker run" и "docker start". Также информация о ключах команды "docker run": -i, -d, -t.
 - С помощью команды "docker exec -it <u_container_id> bash" запущен процесс bash внутри контейнера.
 - С помощью команды "docker commit <u_container_id> nv30/ubuntu-tmp-file" создан образ из нашего контейнера с файлом.
 - В файл docker-1.log добавлен вывод команды "docker images".
 - \*В файл docker-1.log доавлены отличия образа от контейнера на основе выводов команды "docker inspect" для них.
