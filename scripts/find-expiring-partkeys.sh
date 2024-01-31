#!/bin/sh

get_participation_expiration_eta() {
  active_key_last_valid_round=$1
  last_committed_block=$2
  current_key_blocks_remaining=$((active_key_last_valid_round - last_committed_block))

  remaining_seconds=$(echo "${current_key_blocks_remaining}*2.9" | bc)
  current_timestamp=$(date +%s)
  expiration_timestamp=$(echo "${current_timestamp}+${remaining_seconds}" | bc)

  # Convert the new timestamp to a date and time
  expiration_date=$(date -d "@${expiration_timestamp}" '+%Y-%m-%d %H:%M')

  echo "${expiration_date}"
}

# shellcheck disable=SC2002
account_addr=$(cat /voi/accountList.json | jq -r '.DefaultAccount')
last_participation_key_round=$(curl -sSL https://testnet-api.voi.nodly.io/v2/accounts/"$account_addr" | jq -r '.participation."vote-last-valid"')
current_chain_round=$(curl -sSL https://testnet-api.voi.nodly.io/v2/status | jq -r '."last-round"')
difference=$((last_participation_key_round - current_chain_round))

if [ $difference -gt 417104 ]; then
  echo "Key is good. It will expire on $(get_participation_expiration_eta "$last_participation_key_round" "$current_chain_round")"
else
  echo "Key expires: $(get_participation_expiration_eta "$last_participation_key_round" "$current_chain_round")"
  curl -X POST --data "{\"title\": \"Voi Participation Key Update Required\", \"body\": \"Your participation key for account ${account_addr} is expected to expire by $(get_participation_expiration_eta "$last_participation_key_round" "$current_chain_round"). Updating is necessary to participate in the network. \"}" notify:5000
fi
