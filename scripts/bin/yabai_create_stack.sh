#!/bin/bash
: ' ----------------------------------------
* Creation Time : Thu Apr 27 16:16:16 2023
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Get the window information using yabai query command
window_info=$(yabai -m query --windows)

# Get the window IDs for Google Calendar, Calendar, WhatsApp, and Messenger
google_calendar_id=$(echo "$window_info" | jq '.[] | select(.app=="Google Calendar") | .id')
native_calendar_id=$(echo "$window_info" | jq '.[] | select(.app=="Calendar") | .id')
whatsapp_id=$(echo "$window_info" | jq '.[] | select(.app=="WhatsApp") | .id')
messenger_id=$(echo "$window_info" | jq '.[] | select(.app=="Messenger") | .id')
slack_id=$(echo "$window_info" | jq '.[] | select(.app=="Slack") | .id')
anki_id=$(echo "$window_info" | jq '.[] | select(.app=="Anki") | .id')

# Check if all window IDs are found
if [[ -z "$google_calendar_id" || -z "$native_calendar_id" || -z "$whatsapp_id" || -z "$messenger_id" ]]; then
    echo "One or more window IDs not found. Please ensure Google Calendar, Calendar, WhatsApp, and Messenger are open."
    exit 1
fi

# Stack the windows
yabai -m window "$google_calendar_id" --stack "$native_calendar_id"
yabai -m window "$whatsapp_id" --stack "$messenger_id"
yabai -m window "$slack_id" --stack "$anki_id"

echo "Google Calendar (ID: $google_calendar_id) and Calendar (ID: $native_calendar_id) have been stacked."
echo "WhatsApp (ID: $whatsapp_id) and Messenger (ID: $messenger_id) have been stacked."
echo "Slack (ID: $slack_id) and Zoom (ID: $zoom_id) have been stacked."
