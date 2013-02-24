#!/bin/bash

# Monitor the current directory.
# When a .rst file is changed, re-build it
while true; do
  change=$(inotifywait -e close_write,moved_to,create .)
  change=${change#./ * }
  fileext="${change##*.}"
  if [ "$fileext" = "rst" ]
  then
    echo "Detected change in $change. Rebuilding..."
    ./build.sh $change
    echo "Done."
  fi
done
