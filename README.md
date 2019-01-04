# nv30_microservices
nv30 microservices repository

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
