#!/usr/bin/env bash
# Sensitivity check for the host CPU performance/power mode.
#
# Usage:
#   ./scripts/check_performance_mode.sh low
#   # switch Windows/Linux to the other performance mode, then
#   ./scripts/check_performance_mode.sh high
#
# This is a subset of the frozen experiment.  It does not overwrite the main
# results/grid.csv or results/real.csv.  It is a robustness check, not a
# replacement for the frozen protocol.
set -euo pipefail

cd "$(dirname "$0")/.."

TAG="${1:-current}"
if [[ -z "$TAG" ]]; then
    echo "usage: $0 TAG" >&2
    exit 1
fi

./download_data.sh

CPU="${CPU:-0}"
RUN="taskset -c ${CPU}"

${RUN} ./build/astar_research benchmark-grid \
    --out "results/perf_mode_${TAG}_grid.csv" \
    --sizes 128,512 \
    --families open,random,clustered,rooms,maze \
    --reps 3 \
    --per-band 3 \
    --seed 20261030 \
    --time-limit-s 30

${RUN} ./build/astar_research benchmark-real \
    --graph data/roadNet-CA.bin \
    --landmarks data/roadNet-CA.alt16.bin \
    --out "results/perf_mode_${TAG}_real.csv" \
    --reps 3 \
    --per-band 5 \
    --main-k 8 \
    --seed 20261030 \
    --time-limit-s 30

echo
echo "subset written to:"
echo "  results/perf_mode_${TAG}_grid.csv"
echo "  results/perf_mode_${TAG}_real.csv"
