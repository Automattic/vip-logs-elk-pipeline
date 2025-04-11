#!/bin/sh
set -euo pipefail
set -x

MAX_RETRIES=10

echo "Checking if export file exists at $KIBANA_EXPORT_FILE..."
ls -la "$KIBANA_EXPORT_FILE"

import_saved_objects() {
  # Function to import saved objects using a curl request to the Kibana API
  curl -v -s -w "\n%{http_code}" -X POST "$KIBANA_HOST/api/saved_objects/_import" \
    -H "kbn-xsrf: true" \
    -F file=@"$KIBANA_EXPORT_FILE"
}

# Retry loop for importing saved objects
for i in $(seq 1 "$MAX_RETRIES"); do
  echo "Attempt $i to import saved objects..."
  response=$(import_saved_objects)
  code=$(echo "$response" | tail -n1)
  echo "Response code: $code"
  echo "Full response: $response"

  # Check if the import was successful
  if [ "$code" = "200" ] || [ "$code" = "201" ]; then
    echo "Saved objects imported successfully."
    exit 0
  else
    echo "Attempt $i failed (HTTP $code), retrying in 5s..."
    sleep 5
  fi
done

echo "Failed to import saved objects after $MAX_RETRIES attempts."
exit 1