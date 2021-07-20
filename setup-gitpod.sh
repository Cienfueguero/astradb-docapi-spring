#!/bin/bash

function setupTable() {
  if [[ -z "$ASTRA_DB_ID" ]]; then
    echo "What is your Astra database id? Example: 4e62bc79-0e12-4667-bd7d-2191ece2a32c ☁️"
    read -r ASTRA_DB_ID
    export ASTRA_DB_ID="${ASTRA_DB_ID// /}"
    gp env ASTRA_DB_ID="${ASTRA_DB_ID// /}" &>/dev/null
  fi

  if [[ -z "$ASTRA_DB_REGION" ]]; then
    echo "What is your Astra database region? Example: us-east1 🌍"
    read -r ASTRA_DB_REGION
    export ASTRA_DB_REGION="${ASTRA_DB_REGION// /}"
    gp env ASTRA_DB_REGION="${ASTRA_DB_REGION// /}" &>/dev/null
  fi

  if [[ -z "$ASTRA_DB_KEYSPACE" ]]; then
    echo "What is your Astra keyspace name? 🔑"
    read -r ASTRA_DB_KEYSPACE
    export ASTRA_DB_KEYSPACE="${ASTRA_DB_KEYSPACE// /}"
    gp env ASTRA_DB_KEYSPACE="${ASTRA_DB_KEYSPACE// /}" &>/dev/null
  fi

  if [[ -z "$ASTRA_DB_APPLICATION_TOKEN" ]]; then
    echo "What is your Astra token? Example: AstraCS:ZJqbROaTQlPu 🌍"
    read -r ASTRA_DB_APPLICATION_TOKEN
    export ASTRA_DB_APPLICATION_TOKEN="${ASTRA_DB_APPLICATION_TOKEN// /}"
    gp env ASTRA_DB_APPLICATION_TOKEN="${ASTRA_DB_APPLICATION_TOKEN// /}" &>/dev/null
  fi

  eval $(gp env -e)

  # Create tables
  echo "Creating and populating Astra collection persons..."
  curl -s --request PUT \
    --url "https://${ASTRA_DB_ID}-${ASTRA_DB_REGION}.apps.astra.datastax.com/api/rest/v2/namespaces/${ASTRA_DB_KEYSPACE}/collections/persons/1" \
    --header 'content-type: application/json' \
    --header "x-cassandra-token: ${ASTRA_DB_APPLICATION_TOKEN}" \
    --data '{"firstName":"Geni","lastName":"Gomez"}'

  curl -s --request PUT \
    --url "https://${ASTRA_DB_ID}-${ASTRA_DB_REGION}.apps.astra.datastax.com/api/rest/v2/namespaces/${ASTRA_DB_KEYSPACE}/collections/persons/2" \
    --header 'content-type: application/json' \
    --header "x-cassandra-token: ${ASTRA_DB_APPLICATION_TOKEN}" \
    --data '{"firstName":"Steven","lastName":"Matison"}'

  curl -s --request PUT \
    --url "https://${ASTRA_DB_ID}-${ASTRA_DB_REGION}.apps.astra.datastax.com/api/rest/v2/namespaces/${ASTRA_DB_KEYSPACE}/collections/persons/3" \
    --header 'content-type: application/json' \
    --header "x-cassandra-token: ${ASTRA_DB_APPLICATION_TOKEN}" \
    --data '{"firstName":"Ricardo","lastName":"Valdes"}'
}

setupTable

while [ "$ASTRA_DB_APPLICATION_TOKEN" = '' ]; do
  echo "Your database details were invalid. Trying again:"
  unset ASTRA_DB_ID
  unset ASTRA_DB_REGION
  unset ASTRA_DB_KEYSPACE
  setupTable
done