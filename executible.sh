#!/bin/bash

data=$(cat)

request_url="localhost:9494"
rep=$(curl -X POST -d "$data" "$request_url")
status=$?
echo status
