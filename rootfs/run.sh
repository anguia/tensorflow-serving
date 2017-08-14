#!/bin/bash

DAEMON=tf-serving.sh
EXEC=$(which $DAEMON)
ARGS="start-foreground"

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
