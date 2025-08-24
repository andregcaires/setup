#!/bin/bash

if ! command -v docker >/dev/null 2>&1
then
    echo "docker not found"
else 
    ## Postgres + pgAdmin4 dev setup
    echo "[INFO] PostgreSQL + pgAdmin4 setup"
    echo "Inform PGADMIN_DEFAULT_EMAIL"
    read PGADMIN_DEFAULT_EMAIL
    echo "Inform PGADMIN_DEFAULT_PASSWORD"
    read -sp PGADMIN_DEFAULT_PASSWORD


    docker pull postgres
    docker pull dpage/pgadmin4

    docker network create --driver bridge postgres-network

    docker run --name dev-postgresql --network=postgres-network -e "POSTGRES_PASSWORD=1234" -p 5432:5432 -d postgres
    docker run --name dev-pgadmin --network=postgres-network -p 15432:80 -e "PGADMIN_DEFAULT_EMAIL=$PGADMIN_DEFAULT_EMAIL" -e "PGADMIN_DEFAULT_PASSWORD=$PGADMIN_DEFAULT_PASSWORD" -d dpage/pgadmin4
fi
