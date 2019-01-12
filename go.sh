#!/usr/bin/env bash

echo "Running Nexus ..."
docker run -d -p 8081:8081 --name nexus sonatype/nexus3

echo "Wait for Nexus to start ..."
( docker logs -f nexus & ) | grep -q "Started Sonatype Nexus*"

echo "publish our scripts ..."
curl -v -X POST -u "admin:admin123" --header "Content-Type: application/json" "http://192.168.99.101:8081/service/rest/v1/script" -d @create_maven_releases_repo.json
curl -v -X POST -u "admin:admin123" --header "Content-Type: application/json" "http://192.168.99.101:8081/service/rest/v1/script" -d @create_maven_snapshots_repo.json
curl -v -X POST -u "admin:admin123" --header "Content-Type: application/json" "http://192.168.99.101:8081/service/rest/v1/script" -d @create_maven_group_repo.json
curl -v -X POST -u "admin:admin123" --header "Content-Type: application/json" "http://192.168.99.101:8081/service/rest/v1/script" -d @create_rpms_repo.json

echo "check the scripts are there (optional) ..."
curl -v -X GET -u "admin:admin123" "http://192.168.99.101:8081/service/rest/v1/script"

echo "run the scripts ..."
curl -X POST -u "admin:admin123" --header "Content-Type: text/plain" "http://192.168.99.101:8081/service/rest/v1/script/create_maven_releases_repo/run"
curl -X POST -u "admin:admin123" --header "Content-Type: text/plain" "http://192.168.99.101:8081/service/rest/v1/script/create_maven_snapshots_repo/run"
curl -X POST -u "admin:admin123" --header "Content-Type: text/plain" "http://192.168.99.101:8081/service/rest/v1/script/create_maven_group_repo/run"
curl -X POST -u "admin:admin123" --header "Content-Type: text/plain" "http://192.168.99.101:8081/service/rest/v1/script/create_rpms_repo/run"


