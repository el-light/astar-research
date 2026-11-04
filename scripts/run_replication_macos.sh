#!/usr/bin/env bash
# Full pipeline on macOS (no taskset, no nproc), written to
# results/replication_macos/.  The frozen results/ files are not touched.
#
# Build first (Homebrew libomp):
#   cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DOpenMP_ROOT=/opt/homebrew/opt/libomp
#   cmake --build build -j "$(sysctl -n hw.ncpu)"
set -euo pipefail

cd "$(dirname "$0")/.."
OUT=results/replication_macos
mkdir -p "$OUT"
BIN=./build/astar_research
G=data/roadNet-CA.bin
L=data/roadNet-CA.alt16.bin
THREADS_MAX="$(sysctl -n hw.ncpu)"

step() { echo; echo "=== $(date '+%H:%M:%S') $*"; }

step "download + preprocess"
./download_data.sh

step "checksums (compare with results/RUN_LOG.md)"
shasum -a 256 data/roadNet-CA.txt.gz "$G" "$L"

step "core tests"
./build/test_core

step "validate-real"
$BIN validate-real --graph "$G" --landmarks "$L" --samples 30 --main-k 8 --seed 20261030

step "benchmark-grid"
$BIN benchmark-grid --out "$OUT/grid.csv" --sizes 128,256,512,1024 \
    --families open,random,clustered,rooms,maze --reps 3 --per-band 5 --seed 20261030 --time-limit-s 30

step "benchmark-real"
$BIN benchmark-real --graph "$G" --landmarks "$L" --out "$OUT/real.csv" \
    --reps 5 --per-band 10 --main-k 8 --seed 20261030 --time-limit-s 30

step "diagnose-grid"
$BIN diagnose-grid --out "$OUT/grid_diagnostics.csv" --sizes 128,256,512,1024 \
    --families open,random,clustered,rooms,maze --per-band 5 --seed 20261030

step "diagnose-real"
$BIN diagnose-real --graph "$G" --landmarks "$L" --out "$OUT/real_diagnostics.csv" \
    --main-k 8 --per-band 10 --seed 20261030

step "weighted-maze"
$BIN weighted-maze --out "$OUT/weighted_maze.csv" --sizes 128,256,512,1024 \
    --per-band 5 --reps 3 --seed 20261030

step "omp-scaling"
OMP_NUM_THREADS="$THREADS_MAX" $BIN omp-scaling --graph "$G" --landmarks "$L" \
    --out-batch "$OUT/omp_scaling.csv" --out-tasks "$OUT/omp_tasks.csv" \
    --sizes 1024 --threads "1,2,4,8,$THREADS_MAX" --per-band 5 --reps 3 --batch-reps 3 --seed 20261030

step "analysis"
python3 scripts/analyze_replication.py

step "done"
