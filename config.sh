#!/bin/bash

# Default values
relay_url="wss://public.relaying.io"
name="Relaying.io"
description="The public relay for relaying.io"
pubkey="npub1relayng8dfsg3kd0fepkgnl3z25m90jcg27zw9wkwf7tfpd93rasvffghm"
contact="mailto:hello@relaying.io"
favicon="https://nodeless.io/favicon.ico"
address="0.0.0.0"
port="80"
reject_future_seconds="1800"
pubkey_whitelist=("npub1relayng8dfsg3kd0fepkgnl3z25m90jcg27zw9wkwf7tfpd93rasvffghm" "npub1utx00neqgqln72j22kej3ux7803c2k986henvvha4thuwfkper4s7r50e8")

# Parse command-line options
for arg in "$@"; do
    case $arg in
        --relay_url=*)
            relay_url="${arg#*=}"
            ;;
        --name=*)
            name="${arg#*=}"
            ;;
        --description=*)
            description="${arg#*=}"
            ;;
        --pubkey=*)
            pubkey="${arg#*=}"
            ;;
        --contact=*)
            contact="${arg#*=}"
            ;;
        --favicon=*)
            favicon="${arg#*=}"
            ;;
        --address=*)
            address="${arg#*=}"
            ;;
        --port=*)
            port="${arg#*=}"
            ;;
        --reject_future_seconds=*)
            reject_future_seconds="${arg#*=}"
            ;;
        --pubkey_whitelist=*)
            pubkey_whitelist="${arg#*=}"
            # Split the comma-separated values into an array
            IFS=',' read -r -a pubkey_whitelist <<< "$pubkey_whitelist"
            ;;
        *)
            echo "Invalid option: $arg"
            exit 1
            ;;
    esac
done

# Generate the pubkey_whitelist array with quotes and commas
whitelist_array=()
for item in "${pubkey_whitelist[@]}"; do
    whitelist_array+=("\"$item\"")
done

# Join the array elements with commas
whitelist_string=$(IFS=','; echo "${whitelist_array[*]}")

# Generate the config.toml content
config_content="[info]
relay_url = \"$relay_url\"
name = \"$name\"
description = \"$description\"
pubkey = \"$pubkey\"
contact = \"$contact\"
favicon = \"$favicon\"

[network]
address = \"$address\"
port = $port

[options]
reject_future_seconds = $reject_future_seconds

[authorization]
pubkey_whitelist = [
    $whitelist_string
]"

# Write the config.toml file
config_file="/home/ubuntu/relaying-nostr-rs-relay/config.toml"
echo "$config_content" > "$config_file"
echo "Generated config.toml successfully."
