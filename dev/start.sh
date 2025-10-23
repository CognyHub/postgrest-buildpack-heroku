#!/bin/sh
export DATABASE_URL=_CHANGE_
export PGRST_SERVER_HOST=0.0.0.0
export PGRST_SERVER_PORT=3000
export PGRST_DB_URI=${PGRST_DB_URI:-${DATABASE_URL}}
export PGRST_OPENAPI_SERVER_PROXY_URI=https://0.0.0.0 
export POSTGREST_VER=${POSTGREST_VER:-13.0.0}
export PGRST_DB_PRE_CONFIG=_CHANGE_auth.fn_pub_configs

# show configs
./postgrest-v${POSTGREST_VER}-macos postgrest.conf --dump-config

# start process
./postgrest-v${POSTGREST_VER}-macos postgrest.conf