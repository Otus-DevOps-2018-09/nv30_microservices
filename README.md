# nv30_microservices
nv30 microservices repository

## Homework-16: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=gitlab-ci-1)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - В GCE, используя docker-machine, создана n1-standard-1 машина для Gitlab CI.
 - На машину установлен Gitlab CI, используя Omnibus-установку.
 - В Gitlab CI создана группа и принадлежащий ей проект.
 - Создан CI/CD Pipeline для проекта.
 - На машине запущен gitlab-runner, используя docker. Он зарегистрирован в качестве раннера в ранее созданном проекте.
 - В репо добавлено приложение reddit и тест для него. Тест успешно пройден.
 - \*Для автоматизации развертывания большого количества раннеров используются:
   - **Packer** для создания образа в gce на базе ubuntu 16.04 с установленным docker ce. В качестве провиженера используется ansible плейбук с коммьюнити ролью "geerlingguy.docker".
   - **Terraform** для создания инфраструктуры в gce. Количество создаваемых машин можно указать в переменной "vm_count" в файле terraform.tfvars. Машины создаются с тегом "gitlab-runner", чтобы динамический инвентори в Ansible мог их группировать по этому признаку.
   - **Ansible** для запуска контейнера на созданных в gce машинах. Для развертывания и регистрации раннеров используется коммьюнити роль "riemers.gitlab-runner" с необходимыми переменными, прописанными в файле "./gitlab-ci/gitlab-runner/ansible/vars/runner.yml" (в репо лежит соответствующий example-файл). Для dynamic inventory используется gcp_compute.
 - \*Оповещения из CI/CD Pipeline интегрированы со [Slack-чатом](https://devops-team-otus.slack.com/messages/CDE04PHLP).

## Homework-15: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=docker-4)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - Для теста контейнеры запускались с сетевыми драйверами none, host, bridge.
 - Также контейнеры запущены с драйверами none и host с просмотром списка net-namespace'ов.
 - Создана bridge-сеть reddit, в ней запущены контейнеры. Чтобы они начали видеть друг друга, прописаны сетевые алиасы при их запуске.
 - Созданы сети front_net (для ui) и back_net (для mongodb, comment и post). При запуске контейнера docker может подключить к нему только 1 сеть, поэтому контейнеры post и comment подключены к сети front_net командой "docker network connect <network> <container>".
 - Установлен docker-compose и создан файл docker-compose.yml с описанием запуска наших контейнеров.
 - Файл docker-compose.yml обновлен для создания сетей front_net и back_net и подключения к ним необходимых контейнеров. Также в файле параметризованы порт публикации сервиса ui, версии всех сервисов и volume для сервиса post_db. Переменные описаны в файле ".env". В git попадет только файл ".env.example".
 - По умолчанию в качестве имени проекта docker-compose использует имя папки, в который он расположен. Задать имя проекта можно с помощью переменной **COMPOSE_PROJECT_NAME** в файле .env, либо при запуске docker-compose с ключом "-p".
 - \*Создан docker-compose.override.yml:
   - Для запуска puma в дебаг режиме с двумя воркерами в сервисах ui и comment, используется директива **command: "puma --debug -w 2"**.
   - Для возможности изменения кода приложений без сборки образа, выполняется проброс директорий с кодом сервисов с машины docker-host с помощью директивы **volumes**. Поэтому сначала необходимо скопировать директории comment, post-py и ui с локальной машины на docker-host с помощью scp.

## Homework-14: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=docker-3)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - В репозиторий в каталог src добавлены микросервисы приложения reddit: post-py, comment и ui.
 - Для каждого микросервиса создан Dockerfile с необходимыми инструкциями.
 - Собраны образы микросервисов.
   - Сборка ui началась не с первого шага, т.к. использовался кеш после сборки образа comment.
 - Создали bridge-network reddit и запустили контейнеры с сетевыми алиасами из ранее созданных образов.
 - \*Для теста контейнеры запущены с другими сетевыми алиасами. Новые адреса для взаимодействия контейнеров указаны при их запуске, используя ключ --env в таком виде: "--env COMMENT_SERVICE_HOST=test_comment".
 - Оптимизирован Dockerfile сервиса ui и его размер уменьшен на 300+МБ.
   - Сборка началась с первого шага, т.к. мы поменяли базовый образ.
 - \*Собран образ ui на основе Alpine Linux. Устанавливаемые пакеты пришлось заменить на "ruby ruby-bundler ruby-dev ruby-json build-base", чтобы образ собрался и заработал. Без "ruby-json" образ собирался, но не работал. Для дебага необходимо было запустить и зайти в созданный из образа контейнер, используя команду "docker run --rm -it <u_container_id> ash". Внутри контейнера запустить руками puma и увидеть ошибку. Файл с инструкциями на базе Alpine лежит в папке ui и называется Dockerfile.1. Проведены дальнейшие оптимизации всех сервисов:
   - ui: Базовый образ Alpine 3.8. Установка пакетов без использования локального кеша. После установки всех необходимых компонентов удаляется пакет "build-base". Файл Dockerfile.2. Итог 66.4MB.
   - comment: Базовый образ Alpine 3.8. Установка пакетов без использования локального кеша. После установки всех необходимых компонентов удаляется пакет "build-base". Дополнительно понадобилось установить gem "bigdecimal". Файл Dockerfile.1. Итог 64.2MB.
   - post: Установка пакетов без использования локального кеша. Файл Dockerfile.1. Итог 199MB.
 - Создан Docker volume reddit_db и подключен к контейнеру с MongoDB. Теперь после перезапуска контейнеров БД сохраняется.

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
