#!/bin/bash

log_file="/home/phoenix/accesslog/access.log"
success_count=$(grep '200' "$log_file" | wc -l)
echo "Number of successful responses (status code 200): $success_count"
