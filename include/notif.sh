#!/bin/bash

# Function to send notifications using curl
# Purpose: To send notifications using curl with specified parameters
# Parameters:
# 1. content: The content of the notification
# 2. title: The title of the notification
# 3. priority: The priority of the notification
# 4. tags: The tags of the notification
# 5. topic: The topic of the notification
# Return Value: None
# Other Information: The URL for sending notifications is hardcoded in the function
curl_notification() {
  local url=https://ntfy.morgan-jourdin.fr/
  local content="$1"
  content=$(echo -e "$content")
  local title="$2"
  local priority="$3"
  local tags="$4"
  local topic="$5"

  curl -u :tk_1q8i000x9rpzhalp2n6m6hxjq5xtq \
       -d "$content" \
       -H "Title: $title" \
       -H "Priority: $priority" \
       -H "Tags: $tags" \
       $url$topic
}