function setupTable() {

  $Env:ASTRA_DB_ID = Read-Host `
  "What is your Astra database id? 
  Example: 4e62bc79-0e12-4667-bd7d-2191ece2a32c"


  $Env:ASTRA_DB_REGION = Read-Host `
  "What is your Astra database region? `
  Example: us-east1"

  $Env:ASTRA_DB_KEYSPACE = Read-Host `
  "What is your Astra keyspace name?"

  $Env:ASTRA_DB_TOKEN = Read-Host `
  "What is your Astra token? `
  Example: AstraCS:ZJqbROaTQlPu"

   # Create tables
  Write-Output "Creating Astra tables..."

  $headers = @{
    'content-type' = 'application/json'
    'x-cassandra-token' = $Env:ASTRA_DB_TOKEN
  }

  Invoke-RestMethod "https://$Env:ASTRA_DB_ID-$Env:ASTRA_DB_REGION.apps.astra.datastax.com/api/rest/v2/namespaces/$Env:ASTRA_DB_KEYSPACE/collections/persons/1" `
    -Method 'PUT' `
    -Headers $headers `
    -Body '{"firstName":"Geni","lastName":"Gomez"}'
}

setupTable