#!/bin/bash
#SBATCH -p short
#SBATCH --export=ALL
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH --job-name=htop_testcase_2
#SBATCH --output=output/htop_testcase_2.txt

mkdir -p output src

echo "========================================================"
echo "Test Case 2: Monitor a Sample Process Using htop"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start Time: $(date)"
echo "========================================================"

module load htop/3.3.0

# Launch a sample CPU-intensive process in the background (e.g., `yes > /dev/null`)
echo "Launching a sample CPU-intensive process..."
(yes > /dev/null) &
sample_pid=$!

if [ -z "$sample_pid" ]; then
    echo "Error: Failed to launch the sample process."
    echo "End Time: $(date)"
    exit 1
fi

echo "Sample process launched with PID: $sample_pid"

# Run htop in batch mode and capture its output
echo "Running htop in batch mode..."
htop -C > output/htop_sample_process_output.txt 2>&1 &
htop_pid=$!

# Allow htop to run for a few seconds, then terminate it
sleep 5
kill $htop_pid

# Terminate the sample process after testing
kill $sample_pid

if [ $? -eq 0 ]; then
    echo "Sample process and htop terminated successfully."
else
    echo "Error: Failed to terminate processes."
    echo "End Time: $(date)"
    exit 1
fi

# Verify that the sample process was captured by htop
if grep -q "$sample_pid" output/htop_sample_process_output.txt; then
    echo "Sample process detected successfully by htop."
else
    echo "Error: Sample process not detected in htop output."
    echo "End Time: $(date)"
    exit 1
fi

echo "End Time: $(date)"
echo "========================================================"
