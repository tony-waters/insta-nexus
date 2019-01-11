#!/usr/bin/env bash

# set some values
export NEXUS_USERNAME="admin"
export NEXUS_PASSWORD="admin123"
export NEXUS_URL="http://loccalhost:8081"

# run nexus
docker run -d -p 8081:8081 --name nexus sonatype/nexus3

# let it start up ...
sleep 4m

# publish our scripts
curl -v -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: application/json" "$NEXUS_URL/service/rest/v1/script" -d @create_maven_releases_repo.json
curl -v -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: application/json" "${NEXUS_URL}/service/rest/v1/script" -d @create_maven_snapshots_repo.json
curl -v -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: application/json" "${NEXUS_URL}/service/rest/v1/script" -d @create_maven_group_repo.json
curl -v -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: application/json" "${NEXUS_URL}/service/rest/v1/script" -d @create_rpms_repo.json

# check they are there (optional)
curl -v -X GET -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" "${NEXUS_URL}/service/rest/v1/script"

# run the scripts
curl -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: text/plain" "${NEXUS_URL}/service/rest/v1/script/create_maven_releases_repo/run"
curl -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: text/plain" "${NEXUS_URL}/service/rest/v1/script/create_maven_snapshots_repo/run"
curl -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: text/plain" "${NEXUS_URL}/service/rest/v1/script/create_maven_group_repo/run"
curl -X POST -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --header "Content-Type: text/plain" "${NEXUS_URL}/service/rest/v1/script/create_rpms_repo/run"


