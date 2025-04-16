#!/bin/bash

# --- CONFIGURATION ---
IMAGE="deduwka/devops-16:latest"
NETWORK="my-network"
PORT_BASE=8080
CONTAINERS=("srv1" "srv2" "srv3")
CPUS=(0 1 2)
CHECK_INTERVAL=30  # seconds
BUSY_THRESHOLD=10  # CPU usage percent
BUSY_LIMIT=4       # i.e. 2 minutes if CHECK_INTERVAL is 30s
IDLE_LIMIT=4       # same for idling
UPDATE_CHECK_INTERVAL=300 # 5 mins

# --- STATE TRACKERS ---
declare -A busy_counters
declare -A idle_counters

# Pull latest image and detect if new
pull_and_check_update() {
    echo "[INFO] Checking for image updates..."
    local old_id=$(docker inspect --format='{{.Id}}' $IMAGE 2>/dev/null)
    docker pull $IMAGE > /dev/null
    local new_id=$(docker inspect --format='{{.Id}}' $IMAGE 2>/dev/null)
    [[ "$old_id" != "$new_id" ]]
}

# Start container on specific CPU
start_container() {
    local name=$1
    local cpu=$2
    local port=$((PORT_BASE + cpu + 1))
    echo "[INFO] Starting $name on CPU#$cpu (port $port)..."
    docker run -d --name "$name" \
        --cpuset-cpus="$cpu" \
        --network="$NETWORK" \
        -p "$port":8080 \
        "$IMAGE" > /dev/null
}

# Stop and remove a container
stop_container() {
    local name=$1
    echo "[INFO] Stopping and removing $name..."
    docker stop "$name" > /dev/null
    docker rm "$name" > /dev/null
}

# Update running containers (one at a time)
update_containers() {
    echo "[INFO] Updating containers with new image..."
    for name in "${CONTAINERS[@]}"; do
        if docker ps -q -f name="^/${name}$" > /dev/null; then
            echo "[INFO] Updating $name..."
            start_container "${name}_new" "${CPUS[${name:3}-1]}"
            sleep 5
            stop_container "$name"
            docker rename "${name}_new" "$name"
        fi
    done
}

# Main loop
last_update_check=0
while true; do
    current_time=$(date +%s)

    # Check and manage each container
    for i in "${!CONTAINERS[@]}"; do
        name="${CONTAINERS[$i]}"
        cpu="${CPUS[$i]}"
        running=$(docker ps -q -f name="^/${name}$")

        if [ -n "$running" ]; then
            usage=$(docker stats --no-stream --format "{{.CPUPerc}}" "$name" | sed 's/%//')
            usage=${usage%%.*}
            usage=${usage:-0}

            if (( usage > BUSY_THRESHOLD )); then
                ((busy_counters[$name]++))
                idle_counters[$name]=0
            else
                ((idle_counters[$name]++))
                busy_counters[$name]=0
            fi

            # Check if next container should start
            if (( i < 2 )); then
                next="${CONTAINERS[$i+1]}"
                if (( busy_counters[$name] >= BUSY_LIMIT )) && ! docker ps -q -f name="^/${next}$" > /dev/null; then
                    start_container "$next" "${CPUS[$i+1]}"
                fi
            fi

            # Check if current should be stopped (if next exists and idle)
            if (( idle_counters[$name] >= IDLE_LIMIT )) && (( i > 0 )); then
                stop_container "$name"
            fi
        fi
    done

    # Check for image update
    if (( current_time - last_update_check > UPDATE_CHECK_INTERVAL )); then
        if pull_and_check_update; then
            update_containers
        fi
        last_update_check=$current_time
    fi

    sleep $CHECK_INTERVAL
done
