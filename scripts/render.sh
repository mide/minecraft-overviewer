#!/bin/bash
set -o errexit

# Render the Map
if [ "$RENDER_MAP" == "true" ]; then
  overviewer.py --config "$CONFIG_LOCATION" $ADDITIONAL_ARGS
fi

# Render the POI
if [ "$RENDER_POI" == "true" ]; then
  overviewer.py --config "$CONFIG_LOCATION" --genpoi $ADDITIONAL_ARGS
fi
