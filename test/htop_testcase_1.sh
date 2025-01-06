#!/bin/bash
#SBATCH -p short
#SBATCH --export=ALL
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH --job-name=htop_testcase_1
#SBATCH --output=output/htop_testcase_1.txt

mkdir -p output src

echo "========================================================"
echo "Test Case 1: Load htop Module and Verify Version"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start Time: $(date)"
echo "========================================================"

module_name="htop/3.3.0"

echo "Loading module: $module_name"
module load $module_name
if [ $? -ne 0 ]; then
    echo "Error: Failed to load module $module_name"
    echo "End Time: $(date)"
    exit 1
fi

htop_version=$(htop --version | head -n 1 | awk '{print $2}')

if [[ "$htop_version" != "3.3.0" ]]; then
    echo "Error: Incorrect htop version. Expected 3.3.0, got $htop_version"
    echo "End Time: $(date)"
    exit 1
fi

echo "htop version: $htop_version"
echo "Module loaded successfully."

echo "End Time: $(date)"
echo "========================================================"
