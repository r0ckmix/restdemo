v 1.0.1

Добавлен запуск приложения в minikube



application launch in minikube environment added



v 1.0.0

Данный проект предназначен для демонстрации навыков автора в области автоматизации сборки и поставки прикладного програмного обеспечения. Он представляет собой прототип пайплайна Spring Boot REST приложения, реализованного на базе официального Docker-образа Jenkins.
Для запуска проекта необходима оболочка bash, а так же Docker, Helm и Java устанновленные в операционной системе.

Кратко опишем основные этапы сборки.
1. Подготовка образа и запуск контейнера Jenkins.
   На этом этапе в образ Jenkins выполняется установка gradle, ansible и необходимые плагины.
2. Запуск задачи Jenkins.
   При помощи Jenkins CLI выполняется создание учетных данных для GitHub, задания Jenkins и выполняется его запуск.
3. Сборка приложения.
   На этом этапе происходит клонирование репозитория исходных кодов приложения и запуск сборщика gradle.
4. Запуск и проверка работоспособности приложения.
   Эмуляция CD реализована в плейбуке ansible. Скрипт выполняет локальный запуск приложения и отправляет Get-запрос к единственному сервису приложения.

Для демонстрации работоспособности пайплайна, необходимо выполнить bash-скрипт run.sh.



This project is intended to represent author's skills software development automation and deployment. I's a simplified CI/CD pipeline for Spring Boot REST application, based on official Jenkins Docker image.
This project requires bash environment and Docker installation to be launched.

Let's describe the main steps of the build.
1. Image tuning.
   On this stage Jenkins image extends with gradle, ansible and required plugins.
2. Start Jenkins pipeline.
   Jenkins configuration (credential and job creation) and build launch accomplishes by Jenkins CLI.
3. Build application
   There are two steps on this stage: cloning GitHub repository and "gradle build" launching.
4. Run application and smoke test
   Deploy and lauch application implements by ansible. The playbook starts application and test it availability.

To demonstrate how the Pipeline works, you must run the bash script run.sh.