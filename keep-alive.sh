#!/bin/bash

# Start the tmate session and keep it running
tmate -F | tee /var/www/html/index.html &

# Keep the script running indefinitely
while true; do
  sleep 86400  # Sleep for 1 day to keep the loop alive
done
