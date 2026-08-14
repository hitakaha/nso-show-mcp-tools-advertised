#!/bin/bash

# Configuration
URL="http://localhost:8080/mcp"
AUTH="admin:admin"
PAYLOAD='{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'

# Fetch data and store in a variable
response=$(curl -s -u "$AUTH" "$URL" -H "Content-Type: application/json" -d "$PAYLOAD")

# Count total number of tools advertised
tool_count=$(echo "$response" | jq '.result.tools | length')

# Build the report content using a variable
REPORT=""$'\n'
REPORT+="--------------------------------------------------------------------------------"$'\n'
REPORT+="Advertised MCP Tools (Detailed View)"$'\n'
REPORT+="--------------------------------------------------------------------------------"$'\n'

# Safely load names and descriptions into arrays using null-delimited safety from jq
mapfile -t tool_names < <(echo "$response" | jq -r '.result.tools[].name')
mapfile -t tool_descs < <(echo "$response" | jq -r '.result.tools[].description')

# Loop through based on the exact index count
for ((i=0; i<tool_count; i++)); do
    index=$((i + 1))
    name="${tool_names[i]}"
    desc="${tool_descs[i]}"
    
    # Append index and name
    REPORT+=$(printf "%-13s %d" "Tool Index:" "$index")$'\n'
    REPORT+="Tool Name:   $name"$'\n'
    
    # Process description respecting original hard line breaks, then fold to 62 chars
    clean_desc=$(echo "$desc" | tr '\r' '\n')
    
    first_desc_line=true
    while IFS= read -r raw_line || [ -n "$raw_line" ]; do
        # Native bash trim leading/trailing whitespace (replaces xargs and avoids quote errors)
        trimmed_line="${raw_line#"${raw_line%%[![:space:]]*}"}"
        trimmed_line="${trimmed_line%"${trimmed_line##*[![:space:]]}"}"
        
        [ -z "$trimmed_line" ] && continue
        
        folded_chunk=$(echo "$trimmed_line" | fold -s -w 62)
        
        while IFS= read -r chunk_line; do
            if [ "$first_desc_line" = true ]; then
                REPORT+=$(printf "Description: %s" "$chunk_line")$'\n'
                first_desc_line=false
            else
                REPORT+=$(printf "             %s" "$chunk_line")$'\n'
            fi
        done <<< "$folded_chunk"
    done <<< "$clean_desc"
    
    REPORT+="--------------------------------------------------------------------------------"$'\n'
done

REPORT+="Total tools advertised: $tool_count"

# Output the result in the requested format
echo result '"'"$REPORT"'"'
