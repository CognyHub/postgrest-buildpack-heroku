# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Heroku buildpack that packages and deploys **PostgREST v13.0.0** — a standalone web server that auto-generates a REST API from a PostgreSQL schema. The buildpack copies the Linux binary, config, and startup script into the Heroku slug at build time.

## Buildpack Lifecycle

Heroku calls three scripts in sequence:

- [bin/detect](bin/detect) — Always exits 0 (unconditional match)
- [bin/compile](bin/compile) — Copies `postgrest-v13.0.0`, `postgrest.conf`, and `start_postgrest.sh` into the build directory (`$1`)
- [bin/release](bin/release) — Returns empty YAML metadata

## Runtime

[start_postgrest.sh](start_postgrest.sh) is the dyno entry point. It resolves env vars and starts the binary:

```sh
export PGRST_SERVER_PORT=${PGRST_SERVER_PORT:-${PORT:-3000}}
export PGRST_DB_URI=${PGRST_DB_URI:-${DATABASE_URL}}
export PGRST_OPENAPI_SERVER_PROXY_URI=https://${HEROKU_APP_DEFAULT_DOMAIN_NAME}
./postgrest-v${POSTGREST_VER} ./postgrest.conf
```

Required Heroku env vars: `DATABASE_URL`, `PORT`, `HEROKU_APP_DEFAULT_DOMAIN_NAME`.

## Configuration Files

There are three `.conf` files — they are **identical except for `db-pre-config`**:

| File | `db-pre-config` | Purpose |
|---|---|---|
| `postgrest.conf` | `public.pre_config` | Production (copied to slug by `bin/compile`) |
| `postgrest-v13.0.0.conf` | `public.pre_config` | Alternate/versioned copy |
| `dev/postgrest.conf` | `api_config.pre_config` | Local development |

Key config values (shared across all):
- `admin-server-port = 3001` — Health check endpoint
- `db-pool = 10` — Connection pool size
- `db-channel = "pgrst"` — PostgreSQL NOTIFY channel for schema cache reloads
- `db-config = true` — In-database configuration enabled
- `log-level = "error"`
- `jwt-role-claim-key = ".role"`

## Local Development

Edit [dev/start.sh](dev/start.sh) — set `DATABASE_URL` and `PGRST_DB_PRE_CONFIG`, then run:

```sh
# From dev/ directory
DATABASE_URL=postgres://... ./start.sh
```

Uses the macOS binary `dev/postgrest-v13.0.0-macos` instead of the Linux production binary.

## Updating PostgREST Version

1. Replace `postgrest-v13.0.0` (Linux binary) with the new version binary
2. Replace `dev/postgrest-v13.0.0-macos` (macOS binary) with the new version binary
3. Update the version number in filenames and references in `start_postgrest.sh` and `dev/start.sh`
4. Update `postgrest.conf` if needed for API changes

## Heroku Setup

```bash
heroku config:add BUILDPACK_URL=https://github.com/CognyHub/postgrest-buildpack-heroku.git
```
