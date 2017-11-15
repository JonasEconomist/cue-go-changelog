#!/bin/bash

data=$(cat)

#http_status=$(curl -I http://google.com | head -n 1| cut -d $' ' -f2)

request_url="localhost:9494"
rep=$(curl -X POST -d "$data" "$request_url")
status=$?
echo status

# if [ $status = "200" ]; then
#     echo "Success"
#     exit 0
#   else
#     echo "Failed"
#     exit 1
# fi