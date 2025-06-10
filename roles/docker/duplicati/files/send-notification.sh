#!/bin/bash

EVENTNAME=$DUPLICATI__EVENTNAME
OPERATIONNAME=$DUPLICATI__OPERATIONNAME
REMOTEURL=$DUPLICATI__REMOTEURL
LOCALPATH=$DUPLICATI__LOCALPATH

# Sends a notification via HTTP POST request to ntfy.sh
#
# Parameters:
#   $1 (title)    - The title for the notification
#   $2 (message)  - The message content for the notification
#   $3 (priority) - The priority level for the notification (see https://docs.ntfy.sh/publish/#message-priority)
#   $4 (tags)     - Optional tags for the notification (see https://docs.ntfy.sh/publish/#tags-emojis)
#
send_notification() {
  local title="$1"
  local message="$2"
  local priority="${3:-normal}"
  local tags="${4:-}"

  curl \
    -H "Title: $title" \
    -H "Priority: $priority" \
    -H "Tags: $tags" \
    -d "$message" \
    192.168.29.130:9006/70GKKvWksIW9LLPA
}

if [ "$EVENTNAME" == "BEFORE" ]; then
  if [ "$OPERATIONNAME" == "Backup" ]; then
    send_notification "Duplicati Backup Starting" "Starting backup to $REMOTEURL from $LOCALPATH" "high" "outbox_tray"
  elif [ "$OPERATIONNAME" == "Restore" ]; then
    send_notification "Duplicati Restore Starting" "Starting restore from $REMOTEURL to $LOCALPATH" "high" "outbox_tray"
  fi
elif [ "$EVENTNAME" == "AFTER" ]; then
  if [ "$OPERATIONNAME" == "Backup" ]; then
    send_notification "Duplicati Backup Complete" "Backup to $REMOTEURL from $LOCALPATH completed successfully" "high" "inbox_tray"
  elif [ "$OPERATIONNAME" == "Restore" ]; then
    send_notification "Duplicati Restore Complete" "Restore from $REMOTEURL to $LOCALPATH completed successfully" "high" "inbox_tray"
  fi
fi

exit 0