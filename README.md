# nv30_microservices
nv30 microservices repository

## Homework-25: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=kubernetes-5)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - Развёрнут дополнительный пул с более мощными нодами.
 - Установлен ingress-контроллер nginx.
 - Из Helm чарта установлен Prometheus c использованием кастомных переменных.
 - Включены kube-state-metrics и node-exporter.
 - Настроен service discovery по меткам.
 - Включен relabeling для трансляции метрик k8s в метки prometheus.
 - Настроены отдельные job'ы с эндпоинтами каждой компоненты приложения.
 - Из Helm чарта установлена Grafana.
 - Добавлен дашборд "Kubernetes cluster monitoring (via Prometheus)" и ранее созданные дашборды из предыдущих ДЗ.
 - Сделан templating ранее созданных дашбордов с добавлением возможности выбора окружения.
 - \*Запущен alertmanager и настроена отправка оповещений о падении api сервер и нод.
 - \*По мануалу созданы [манифесты](https://github.com/Otus-DevOps-2018-09/nv30_microservices/tree/kubernetes-5/kubernetes/prometheus-operator) для разворачивания в k8s кластере prometheus-operator. Настроен мониторинг post endpoints.
 - Двум мощным нодам из кластера добавлен лейбл elastichost=true.
 - Созданы манифесты для разворачивания EFK стека в k8s кластере и проверена его работа.
 - \*Создан [Helm чарт](https://github.com/Otus-DevOps-2018-09/nv30_microservices/tree/kubernetes-5/kubernetes/Charts/efk) для установки стека EFK.

## Homework-24: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=kubernetes-4)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - На локальную машину установлен Helm, в кластер k8s установлен Tiller. Версии 2.12.3.
 - Создан манифест для добавления сервисного аккаунта tiller в кластер.
 - Созданы Chart'ы для деплоя в k8s кластер сервисов ui, comment и post. Chart'ы шаблонизированы с помощью темплейтов.
 - В созданные Chart'ы добавлены helper'ы для генерации шаблона **{{ .Release.Name }}-{{ .Chart.Name }}**. В самих темплейтах сервисов шаблон заменен на вызов функции **{{ template "comment.fullname" . }}** из helper'а.
 - Для полноценного деплоя приложения reddit создан общий Chart, где в файле requirements.yaml описаны необходимые для деплоя приложения зависимости.
 - В Chart сервиса ui добавлено описание переменных окружения POST_SERVICE_HOST, POST_SERVICE_PORT, COMMENT_SERVICE_HOST и COMMENT_SERVICE_PORT для того, чтобы он мог связаться с сервисами comment и post.
 - Gitlab CI установлен в кластер k8s с помощью Helm.
 - В Gitlab CI создана группа и проекты comment, post, ui и reddit-deploy. Проекты comment, post и ui созданы на основе соответствующих Chart'ов. Проект reddit-deploy создан на базе исходников сервисов.
 - Для проектов comment, post и ui настроен Pipeline на сборку образов, тест и релиз приложения при коммите в ветку master. При коммите в другие бранчи создается соответствующее окружение с возможностью удаления по кнопке.
 - В проекте reddit-deploy настроен Pipeline для деплоя релизов приложений в окружение staging и по кнопке в окружение production. Pipeline не собирает образы Docker и использует только окружения staging и production.
 - \*В проектах comment, post и ui добавлена стадия [**master_deploy**](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/a1582f29fd80ddfa1b53a211549af863c24ae6fd/src/comment/.gitlab-ci.yml#L82) в Pipeline. В проекте reddit-deploy в настройках CI/CD добавлен триггер и токен для его активации. Значение токена присвоено переменной **$CI_MASTER_DEPLOY_TOKEN** в настройках группы, которой принадлежат проекты. При сборке приложения из ветки master в этой стадии устанавливается curl и по API дергается Pipeline проекта reddit-deploy для выкатки приложения в staging/production:
```
 curl -X POST -F token=$CI_MASTER_DEPLOY_TOKEN -F ref=master http://gitlab-gitlab/api/v4/projects/5/trigger/pipeline
```

## Homework-23: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=kubernetes-3)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - В сервисе ui включен Load Balancer (изменен тип сервиса с NodePort на LoadBalancer) с открытым портом 80 для доступа извне.
 - Для полноценного управления трафиком на L7 с терминацией SSL создан Ingress и соответствующий Ingress Controller (встроенный в GCS).
 - Отключен первый созданный LoadBalancer и настроен путь "/*" на втором, при запросе которого трафик балансируется с помощью Ingress.
 - Создан сертификат tls. Далее он загружен в k8s кластер путем создания secret'а с помощью kubectl. Следом Ingress настроен на прием только https трафика.
 - \*Создан [k8s манифест](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/kubernetes-3/kubernetes/reddit/secret/secret.yml) с описанием создаваемого выше secret'а. Для добавления сертификата в k8s кластер, необходимо сначала его создать, а потом в зашифрованном в base64 виде передать kubectl. Создание secret'а в кластере происходит по команде:
```
sed "s/TLS_CRT/`cat tls.crt|base64 -w0`/g" secret.yml | \
sed "s/TLS_KEY/`cat tls.key|base64 -w0`/g" | \
kubectl apply -n dev -f -
```
 - Включена поддержка network-policy в GKE. Настроен манифест с сетевыми политиками, разрешающими доступ к сервису mongodb только сервисам comment и post.
 - Хранилище - тип Volume. Создан диск в GCE. Тип volume в деплойменте mongo заменен на **gcePersistentDisk** с указанием использовать созданный диск (указателем служит имя диска, указанное в **pdName**).
 - Хранилище - тип PersistentVolume. Создано [описание](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/kubernetes-3/kubernetes/reddit/mongo-volume.yml) PersistentVolume и с помощью него создан диск в GCE. 
 - Запрос части хранилища - статический. Для выделения части PV приложению создано описание запроса - [PersistentVolumeClaim](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/kubernetes-3/kubernetes/reddit/mongo-claim.yml). Статический PVC подключен к Pod'ам путем изменения описания volume в деплойменте mongo.
 - Запрос части хранилища - динамический. Создано [описание](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/kubernetes-3/kubernetes/reddit/storage-fast.yml) StorageClass'а и с помощью него StorageClass добавлен в кластер k8s. Создано [описание](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/kubernetes-3/kubernetes/reddit/mongo-claim-dynamic.yml) PVC с использованием StorageClass, вместо PV, как было в случае статического выделения хранилища приложению. Динамический PVC подключен к Pod'ам путем изменения описания volume в деплойменте mongo.

## Homework-22: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=kubernetes-2)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - С помощью minikube развернут локальный k8s кластер. Автоматически прописана конфигурация для kubectl.
 - Дописаны деплойменты для сервисов приложения reddit. Добавлены services для связи между сервисами приложения. Появились записи в dns и приложения узнали как взаимодействовать друг с другом.
 - Добавлены services для связи сервисов comment и ui с mongodb. В описание деплойментов добавлены соответствующие переменные окружения.
 - Добавлен сервис для доступа к ui извне. Тип сервиса - NodePort.
 - Включен и проверен dashboard.
 - Добавлен namespace "dev". В нем развернуто приложение reddit. Также добавлено отображение названия namespace при рендере страницы приложения.
 - Кластер k8s развернут в GKE. В нем развернуто приложение reddit.
 - Запущен Dashboard, выданы права сервисному аккаунту и проверена его работа с помощью kubectl proxy.
 - \*Кластер k8s развернут с помощью [Terraform](https://github.com/Otus-DevOps-2018-09/nv30_microservices/tree/kubernetes-2/kubernetes/terraform). Используется remote backend и создается новый node pool для кластера. Создание кластера и правила в fw описаны в виде модулей.
 - \*Создан [dashboard-admin.yaml](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/kubernetes-2/kubernetes/reddit/dashboard-admin.yaml) с добавлением необходимых прав сервисному аккаунту для полноценной работы Dashboard.

## Homework-21: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=kubernetes-1)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - Созданы deployment манифесты для сервисов mongo, comment, post и ui.
 - В GCE развернут Kubernetes кластер, используя туториал "Kubernetes The Hard Way".
 - Созданные во время прохождения туториала файлы лежат в папке [the_hard_way](https://github.com/Otus-DevOps-2018-09/nv30_microservices/tree/kubernetes-1/kubernetes/the_hard_way).
 - Запущены pod'ы из ранее созданных deployment'ов для сервисов.
 - \*Создана заготовка для развертывания кластера Kubernetes по туториалу с помощью Ansible. Т.к. по заданию у нас "Proof of Concept", для автоматизации выбрал третий шаг - **03-compute-resources**. Необходимые для авторизации и деплоя в GCE переменные определены в [defaults/main.yml](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/kubernetes-1/kubernetes/ansible/roles/03-compute-resources/defaults/main.yml) роли и зашифрованы с помощью Ansible Vault. Создаются сети, правила fw, 3 контроллера и 3 воркера с необходимыми **pod-cidr** в metadata.
   - Из проблем - с помощью Ansible нельзя указать конкретные private-ip для создаваемых инстансов, как это сделано в туториале с помощью gcloud cli.

## Homework-20: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=logging-1)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - Обновлен код микросервисов для добавления логирования. Пересобраны образы с тегом logging.
 - Создан docker-compose файл для поднятия стека EFK (ElasticSearch, Fluentd, Kibana). Создан файл конфигурации fluent.conf, который добавляется в образ fluentd при сборке.
 - В docker-compose для сервисов определен драйвер fluentd для логирования сервиса post.
 - Логи от сервиса post доставлены с помощью fluentd в ElasticSearch и отображаются в Kibana.
 - В конфиг fluentd добавлен фильтр для парсинга json логов от сервиса post. Теперь лог в Kibana разбит на поля и нормально читаем.
 - В docker-compose для сервисов определен драйвер fluentd для логирования сервиса ui. От него идут неструктурированные логи.
 - Логи от ui распарсены с помощью регулярного выражения, которое добавлено в конфиг fluentd. Не очень удобно.
 - Регулярное выражение заменено на grok-шаблон "RUBY_LOGGER". Он парсит не все данные, поэтому в конфиг fluentd добавлен grok_pattern для парсинга оставшихся нетронутыми данных.
 - \*Сервис ui шлет логи о запросах к страницам, которые не парсит текущая конфигурация fluentd. По этой причине добавлен дополнительный паттерн:
 ```
 pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATHPARAM:request} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IP:remote_addr} \| method= %{WORD:method} \| response_status=%{INT:response_status}
 ```
  - \*В docker-compose для сервисов логирования добавлен Zipkin, который используется для распределенного трейсинга приложений. Чтобы сервисы собирали данные о запросах, в их описание в конфиге docker-compose добавлена переменная окружения **ZIPKIN_ENABLED**, значение которой задается в .env файле. Далее скачаны исходники с багом, из-за которого страница поста загружается около 3 секунд. С помощью Zipkin можно определить, что проблема возникает при запросе к сервису post и далее уже в нем нужно искать конкретную ошибку.

## Homework-19: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=monitoring-2)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - Поднятие сервисов для приложения и мониторинга разнесены по разным docker-compose файлам.
 - Добавлен запуск cAdvisor в docker-compose и job для него в конфиг Prometheus.
 - Добавлен запуск Grafana в docker-compose для визуализации данных из Prometheus.
 - Добавлен dashboard для визуализации метрик по Docker'у из cAdvisor авторства Thibaut Mottet.
 - В конфигурацию Prometheus добавлен job post для сбора метрик из нашего сервиса post.
 - Создан dashboard с графиками запросов по http к ui сервису и частотой http запросов с кодом возврата 4xx или 5xx.
 - На dashboard добавлен график 95-го процентиля времени ответа на запрос сервисом ui.
 - Создан dashboard с графиками для мониторинга бизнес метрик - счетчиками постов и комментариев.
 - Добавлен [Dockerfile](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/monitoring-2/monitoring/alertmanager/Dockerfile) для сборки образа alertmanager с копированием локального конфига. Запуск alertmanager добавлен в docker-compose, job добавлен в конфиг Prometheus.
 - В файл [alerts.yml](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/monitoring-2/monitoring/prometheus/alerts.yml) добавлено правило для оповещения о падении инстанса в тестовый канал slack.
 - \*В [Makefile](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/monitoring-2/Makefile) добавлены сборка и push образов для alertmanager и telegraf.
 - \*Включена отдача метрик в экспериментальном режиме самим Docker демоном. Добавлен соответствующий job в конфиг Prometheus. Для визуализации выбран [дэшборд от Ciro S. Costa](https://github.com/cirocosta/sample-collect-docker-metrics). [Docker_Daemon.json](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/monitoring-2/monitoring/grafana/dashboards/Docker_Daemon.json). Метрик меньше, чем в cAdvisor и нельзя мониторить "per container".
 - \*Добавлен [Dockerfile](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/monitoring-2/monitoring/telegraf/Dockerfile) для сборки образа telegraf с копированием локального конфига. Запуск telegraf добавлен в docker-compose, job добавлен в конфиг Prometheus. Создан дэшборд на основе дэшборда для cAdvisor от Thibaut Mottet. [Docker_Telegraph.json](https://github.com/Otus-DevOps-2018-09/nv30_microservices/blob/monitoring-2/monitoring/grafana/dashboards/Docker_Telegraph.json). Метрик много и можно сравнивать с cAdvisor.
  - \*Добавлен алерт на 95-й процентиль времени ответа сервиса ui. Оповещение уходит при превышении порога 0.08 в течении 1 минуты.
  - \*Добавлена интеграция alertmanager с email. Тестовое письмо ушло, используя smtp сервер google со сгенерированным паролем приложения для почты.
 - [Docker Hub](https://hub.docker.com/u/nv30)

## Homework-18: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=monitoring-1)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - В GCE, используя docker-machine, создана n1-standard-1 машина для Prometheus. Открыты порты 9090 и 9292.
 - Prometheus v2.1.0 запущен из официального образа в Docker Hub.
 - Создан свой образ Prometheus, в который при сборке добавлен файл конфигурации "prometheus.yml".
 - Пересобраны образы сервисов comment, post-py и ui с поддержкой healthcheck. Переписан docker-compose.yml для поднятия сервисов и Prometheus.
 - Добавлен Node exporter для сбора информации о работе docker-host.
 - \*Добавлен **Percona MongoDB Exporter** для сбора информации о MongoDB. Образ с ним собирается из исходников. [Dockerfile](monitoring/percona-mongodb-exporter/Dockerfile).
 - \*Добавлен **Cloudprober exporter** для мониторинга по прицнипу blackbox. Используется официальный стабильный образ из Hub'а -  cloudprober/cloudprober:v0.10.0. Конфигурация передается через ключ cloudprober_config в метаданных проекта в GCE и выглядит так:
```
probe {
  name: "comment"
  type: HTTP
  targets {
    host_names: "comment"
  }
  interval_msec: 6000
  timeout_msec: 1000
  http_probe {
    port: 9292
  }
}
probe {
  name: "post"
  type: HTTP
  targets {
    host_names: "post"
  }
  interval_msec: 4000
  timeout_msec: 1000
  http_probe {
    port: 9292
  }
}
probe {
  name: "ui"
  type: HTTP
  targets {
    host_names: "ui"
  }
  interval_msec: 2000
  timeout_msec: 1000
  http_probe {
    port: 9292
  }
}
```
 - \*Создан [Makefile](Makefile) для сборки образов и push'а их в Docker Hub. Перед стартом проверяется определена ли переменная USER_NAME. Переменная определяется в файле Makefile.vars, в репо лежит example дял него.
 - [Docker Hub](https://hub.docker.com/u/nv30)


## Homework-17: [![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices.svg?branch=gitlab-ci-2)](https://travis-ci.com/Otus-DevOps-2018-09/nv30_microservices)

 - В Gitlab CI создан проект example2 и к нему закреплен созданный ранее для проекта example раннер.
 - В конфигурации Gitlab CI описаны определения dev, stage и production окружений. Для stage и production окружений добавлены ограничения для запуска job'а с их определением (обязательный tag в git формата x.x.x).
 - Создан job с определением динамического окружения при пуше всех веток кроме master.
 - \*Для управления инфраструктурой и деплоя сервисов приложения был создан образ **nv30/ansiblerraform** на базе ubuntu:16.04. В нем установлены Terraform, Ansible и необходимые компоненты. Конфиг в файле "./gitlab-ci/ansiblerraform/Dockerfile".
 - \*Файл для авторизации на GCP и ключи пользователя appuser передаются через переменные окружения в Gitlab CI. Изначально они были зашифрованы, используя base64. Во время выполнения пайплайна они расшифровываются и копируются в соответствующие файлы.
 - \*При пуше в Gitlab CI создается сервер в GCE с помощью Terraform.
   - Конфиги Terraform лежат в папке "./gitlab-ci/branch_review_env".
   - Для сохранения tfstate использую директиву **cache** внутри пайплайна. После отработки Terraform его tfstate падает в папку с именем **${CI_COMMIT_SHORT_SHA}**, чтобы можно было спокойно работать с несколькими пайплайнами параллельно. Также **${CI_COMMIT_SHORT_SHA}** используется в качестве тега для создаваемых в GCE машин.
 - \*Созданное окружение можно удалить по кнопке delete_branch_review_env в пайплайне.
 - \**В шаг build добавлена сборка контейнеров с сервисами comment, post и ui, а также их push в локальный Gitlab CI Container Registry.
   - Docker в раннере не мог сбилдить образы пока не изменил volumes в config.toml раннера:
```
  volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
```
 - \**Для полноценной работы registry пришлось:
   - Перевести Gitlab CI на https. Встроенное в Omnibus-установку получение сертификата от Letsencrypt не взлетело, поэтому получил и добавил руками.
   - Повесить registry на отличный от Gitlab CI порт, чтобы оба сервиса работали по одному адресу.
   - В итоге в docker-compose.yml для поднятия Gitlab CI были добавлены следующие параметры:
```
  web:
  ...
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'https://34.76.114.32.sslip.io'
      registry_external_url 'https://34.76.114.32.sslip.io:4567'
      letsencrypt['enable'] = false
      nginx['ssl_certificate'] = "/opt/gitlab/embedded/ssl/letsencrypt/fullchain.pem"
      nginx['ssl_certificate_key'] = "/opt/gitlab/embedded/ssl/letsencrypt/privkey.pem"
      registry_nginx['ssl_certificate'] = "/opt/gitlab/embedded/ssl/letsencrypt/fullchain.pem"
      registry_nginx['ssl_certificate_key'] = "/opt/gitlab/embedded/ssl/letsencrypt/privkey.pem"
  ports:
    ...
    - '4567:4567'
  volumes:
    ...
    - '/srv/gitlab/letsencrypt:/opt/gitlab/embedded/ssl/letsencrypt'
```
 - \**Для деплоя сервисов используется Ansible. Файл .env для docker-compose собирается из темплейта, используя переменные окружения, которые передаются из Gitlab CI в Ansible. Конфиги Ansible и Docker Compose лежат в папке "./gitlab-ci/deploy_app".

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
