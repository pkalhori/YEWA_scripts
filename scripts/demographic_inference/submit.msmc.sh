#!/usr/bin/env bash

#!/usr/bin/env bash

samples=(
  JC105 JC108 JC116 JC119 JC120 JC121 JC122 JC123 JC125 JC127 JC131 
  KF6149 LF6101 LF6102 LF6119 LF6146 LF6148 PK01 JC64 JC65 JC66 
  JC67 JC68 JC69 LF6126 LF6127 LF6128 LF6129 LF6130 LF6131 LF6132 
  LF6134 LF6135 LF6137 LF6138 LF6139 JC70 JC71 JC77 JC78 JC79 
  JC80 JC83 JC86 JC87 JC90 JC91 JC92 JC93 JC94 JC95 JC96 JC97 JC98
)

MAX_JOBS=6        # Your group's "Sweet Spot"
USER_NAME="pkalhori"
SLEEP_TIME=60     # How many seconds to wait between checks

echo "Starting throttled submission for ${#samples[@]} samples..."

for ind in "${samples[@]}"; do
    # 1. Count how many jobs you currently have running or pending
    # -h removes the header, wc -l counts the lines
    current_count=$(squeue -u "$USER_NAME" -h | wc -l)

    # 2. If you are at the limit, wait until a job finishes
    while [ "$current_count" -ge "$MAX_JOBS" ]; do
        echo "Limit of $MAX_JOBS reached. Waiting $SLEEP_TIME seconds for a slot..."
        sleep "$SLEEP_TIME"
        current_count=$(squeue -u "$USER_NAME" -h | wc -l)
    done

    # 3. Submit the next individual
    echo "Submitting individual: $ind"
    sbatch msmc_slurm.sh "$ind"
    
    # Small 2-second pause to prevent Slurm from getting dizzy
    sleep 2
done

echo "All samples have been submitted to the queue!"