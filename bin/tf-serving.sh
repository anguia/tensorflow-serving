#!/bin/bash

usage="$(basename "$0") [--help] [start|start-foreground|stop|status] -- Wrapper to start the tensorflow service"

is_tensorflow_serving_running() {
    PID=''
    RUNNING=0
    if [ -f "/serving/tmp/tf-serving.pid" ]; then
        PID=$(cat "/serving/tmp/tf-serving.pid")
    fi
    if [ -n "${PID}" ] && kill -0 $PID 2>/dev/null ; then
        RUNNING=1
    else
        RUNNING=0
    fi
    return $RUNNING
}

case "$1" in
    --help)
        echo "$usage"
        exit
        ;;
    start)
        is_tensorflow_serving_running
        RUNNING=$?
        if [ $RUNNING -eq 0 ]; then
            echo "TensorFlow Serving is not running... starting server in background mode"
            tensorflow_model_server --port=9000 --model_config_file="/serving/conf/tf-serving.conf" --file_system_poll_wait_seconds=5 > "/serving/log/tf-serving.log" 2>&1 &
            echo $! > "/serving/tmp/tf-serving.pid"
        else
            echo "TensorFlow Serving is already running"
        fi
        ;;
    start-foreground)
        is_tensorflow_serving_running
        RUNNING=$?
        if [ $RUNNING -eq 0 ]; then
            echo "TensorFlow Serving is not running... starting server in foreground mode"
            tensorflow_model_server --port=9000 --model_config_file="/serving/conf/tf-serving.conf" --file_system_poll_wait_seconds=5
        else
            echo "TensorFlow Serving is already running"
        fi
        ;;
    stop)
        if [ -f "/serving/tmp/tf-serving.pid" ]; then
            echo "Stopping TensorFlow Serving"
            PID=$(cat "/serving/tmp/tf-serving.pid")
            kill -0 $PID > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                kill -INT $PID
            fi
            rm "/serving/tmp/tf-serving.pid"
        else
            echo "TensorFlow Serving is not running"
        fi
        ;;
    status)
        is_tensorflow_serving_running
        RUNNING=$?
        if [ $RUNNING -eq 0 ]; then
            echo "TensorFlow Serving is not running"
        else
            echo "TensorFlow Serving is running"
        fi
        ;;
    *)
        echo "echo $usage"
        exit 1
        ;;
esac
