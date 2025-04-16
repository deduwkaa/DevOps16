#!/bin/bash

IMAGE="deduwka/devops-16:latest"
CPU_CORES=(0 1 2)
CONTAINERS=("srv1" "srv2" "srv3")
PORTS=(8081 8082 8083)
CHECK_INTERVAL=10
BUSY_THRESHOLD=70.0
IDLE_THRESHOLD=5.0

launch_container() {
    local name=$1
    local core=$2
    local port=$3
    echo "Launching container $name on CPU core#$core..."
    docker run -d --name $name --cpuset-cpus=$core -p $port:8080 $IMAGE

    echo "Waiting 15 seconds to build docker"
    sleep 15
}

get_cpu_usage() {
    local name=$1
    docker stats --no-stream --format "{{.CPUPerc}}" $name | sed 's/%//'
}

stop_container() {
    local name=$1
    echo "Stopping container $name..."
    docker kill --signal=SIGINT $name
    docker wait $name
    docker rm $name
}

active_containers=()
launch_container "${CONTAINERS[0]}" "${CPU_CORES[0]}" "${PORTS[0]}"
active_containers+=("${CONTAINERS[0]}")

while true; do
    for i in "${!CONTAINERS[@]}"; do
        name="${CONTAINERS[$i]}"

        if [[ $(docker ps -q --filter "name=$name") ]]; then
            cpu_usage=$(get_cpu_usage "$name")
            echo "Container $name: CPU usage = $cpu_usage%"

            if (( $(echo "$cpu_usage > $BUSY_THRESHOLD" | bc -l) )) && [[ $i -lt 2 ]]; then
                next_name="${CONTAINERS[$i+1]}"
                if ! [[ "${active_containers[@]}" =~ $next_name ]]; then
                    launch_container "$next_name" "${CPU_CORES[$i+1]}" "${PORTS[$i+1]}"
                    active_containers+=("$next_name")
                fi
            fi

            if (( $(echo "$cpu_usage < $IDLE_THRESHOLD" | bc -l) )) && [[ $i -gt 0 ]]; then
                echo "Container $name is idle. Stopping..."
                stop_container "$name"
                active_containers=("${active_containers[@]/$name}")
            fi
        fi
    done

    echo "Checking for image updates..."
    pullResult=$(docker pull $IMAGE | grep "Downloaded newer image")
    if [[ -n "$pullResult" ]]; then
        echo "New image update found. Restarting containers..."
        for name in "${active_containers[@]}"; do
    stop_container "$name"
    for i in "${!CONTAINERS[@]}"; do
        if [[ "${CONTAINERS[$i]}" == "$name" ]]; then
            launch_container "$name" "${CPU_CORES[$i]}" "${PORTS[$i]}"
            break
        fi
    done
    
    fi

    sleep $CHECK_INTERVAL
done
