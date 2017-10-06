#!/bin/bash
set -eu

cf_network=$(
  jq -n \
    --arg network_name "$NETWORK_NAME" \
    --arg other_azs "$DEPLOYMENT_NW_AZS" \
    --arg singleton_az "$ERT_SINGLETON_JOB_AZ" \
    '
    {
      "network": {
        "name": $network_name
      },
      "other_availability_zones": [
        {
          "name": "null"
        }
      ],
      "singleton_availability_zone": {
        "name": "null"
      }
    }
    '
)

om-linux \
  --target https://$OPSMAN_DOMAIN_OR_IP_ADDRESS \
  --username "${OPSMAN_USERNAME}" \
  --password "${OPSMAN_PASSWORD}" \
  --skip-ssl-validation \
  configure-product \
  --product-name p-windows-runtime \
  --product-network "$cf_network" \
