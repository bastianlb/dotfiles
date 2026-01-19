alias sq='squeue -u $USER -o "%.18i %.30P %.20j %.5t %.10M %.6D %R"'

# Function to count total GPUs in a given partition
gpu_total() {
    local partition=$1
    sinfo -p "$partition" -N -o "%G" | grep -o 'gpu:[0-9]*' | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum+0}'
}

# Function to count used GPUs in a given partition
gpu_used() {
    local partition=$1
    squeue -p "$partition" -O gres:50 | grep -o 'gpu:[0-9]*' | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum+0}'
}

# Function to count free GPUs in a given partition
gpu_free() {
    local partition=$1
    local total=$(gpu_total "$partition")
    local used=$(gpu_used "$partition")
    local free=$((total - used))
    if [ "$free" -lt 0 ]; then free=0; fi  # Ensure non-negative output
    echo "$free"
}

# Function to count pending GPUs in a given partition
gpu_pending() {
    local partition=$1
    squeue -p "$partition" -t PENDING -O gres:50 | grep -o 'gpu:[0-9]*' | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum+0}'
}

# Function to count pending jobs in a given partition
jobs_pending() {
    local partition=$1
    squeue -p "$partition" -t PENDING -h | wc -l
}

# Function to show free GPUs for all GPU partitions (hgx/dgx)
gpu_free_all() {
    echo "GPU Status by Partition (Free/Total | Pending GPUs | Pending Jobs):"
    echo "===================================================================="
    printf "%-25s %9s  %11s  %12s\n" "PARTITION" "FREE/TOT" "PEND GPUs" "PEND JOBS"
    echo "--------------------------------------------------------------------"

    # Get all partitions with hgx or dgx that have GPU GRES
    local partitions=$(sinfo -o "%P %G" | grep -E "(hgx|dgx)" | grep -v "(null)" | awk '{print $1}' | sed 's/\*$//')

    local total_free=0
    local total_gpus=0
    local total_pending_gpus=0
    local total_pending_jobs=0

    # Convert to array for zsh compatibility
    local partition_array
    partition_array=(${(f)partitions})

    for partition in "${partition_array[@]}"; do
        # Skip empty lines
        [[ -z "$partition" ]] && continue

        # Inline the logic to avoid function call issues
        local total=$(sinfo -p "$partition" -N -o "%G" | grep -o 'gpu:[0-9]*' | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum+0}')
        local used=$(squeue -p "$partition" -t RUNNING -O gres:50 | grep -o 'gpu:[0-9]*' | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum+0}')
        local pending_gpus=$(squeue -p "$partition" -t PENDING -O gres:50 | grep -o 'gpu:[0-9]*' | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum+0}')
        local pending_jobs=$(squeue -p "$partition" -t PENDING -h 2>/dev/null | wc -l)

        # Handle empty results
        [[ -z "$total" ]] && total=0
        [[ -z "$used" ]] && used=0
        [[ -z "$pending_gpus" ]] && pending_gpus=0
        [[ -z "$pending_jobs" ]] && pending_jobs=0

        local free=$((total - used))
        [[ "$free" -lt 0 ]] && free=0

        printf "%-25s %3d/%-3d    %5d        %5d\n" "$partition" "$free" "$total" "$pending_gpus" "$pending_jobs"

        total_free=$((total_free + free))
        total_gpus=$((total_gpus + total))
        total_pending_gpus=$((total_pending_gpus + pending_gpus))
        total_pending_jobs=$((total_pending_jobs + pending_jobs))
    done

    echo "===================================================================="
    printf "%-25s %3d/%-3d    %5d        %5d\n" "TOTAL" "$total_free" "$total_gpus" "$total_pending_gpus" "$total_pending_jobs"
}

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash  # Disabled - using .fzf.zsh instead (bash syntax breaks in zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export DSSSCRATCH='/dss/dssmcmlfs01/pn49ze/pn49ze-dss-0001/bastianl/'
source ~/.conda_init
