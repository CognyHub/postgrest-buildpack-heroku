#!/bin/sh

export PGRST_SERVER_HOST=0.0.0.0
export PGRST_SERVER_PORT=${PGRST_SERVER_PORT:-${PORT:-3000}} 
export PGRST_DB_URI=${PGRST_DB_URI:-${DATABASE_URL}}
export PGRST_OPENAPI_SERVER_PROXY_URI=https://${HEROKU_APP_DEFAULT_DOMAIN_NAME} 
export POSTGREST_VER=${POSTGREST_VER:-13.0.0}

# show configs
./postgrest-v${POSTGREST_VER} ./postgrest.conf --dump-config

# start process
./postgrest-v${POSTGREST_VER} ./postgrest.conf

