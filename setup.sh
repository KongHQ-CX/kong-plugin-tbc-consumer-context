export KONG_VERSION=3.8.0.0
export KONG_LICENSE_DATA=$(cat ./license.json)
pongo run --redis
pongo expose