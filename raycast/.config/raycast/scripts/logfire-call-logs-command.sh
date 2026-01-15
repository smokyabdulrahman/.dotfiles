#!/bin/bash

# Raycast Script Command
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Call Log
# @raycast.mode fullOutput
# @raycast.packageName Smoky Scripts
# @raycast.argument1 { "type": "text", "placeholder": "call id", "percentEncoded": true }
#
# Optional parameters:
# @raycast.icon 🪵
# @raycast.currentDirectoryPath ~
# @raycast.needsConfirmation false
#
# Documentation:
# @raycast.description show logs by call-id
# @raycast.author Smoky
# @raycast.authorURL https://github.com/smokyabdulrahman

open "https://logfire-eu.pydantic.dev/mawj/mawj-service?q=attributes-%3E%3E'call.id'%3D'$1'"
