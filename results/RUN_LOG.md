# Run log

Date: 2026-10-30.
Protocol: `PROTOCOL.md` (frozen before the main run).

## Environment

- CPU: Intel Core Ultra 9 285H, 16 logical CPUs.
- RAM: 30 GiB.
- OS: Ubuntu 24.04.5 LTS on WSL2, kernel 6.6.87.1-microsoft-standard-WSL2.
- Compiler: GCC 13.3.0, C++20, CMake 4.4.2, Release (`-O3 -DNDEBUG`).
- Timing: one CPU via `taskset -c 0`; process memory cap
  `ulimit -v 4194304` (4 GiB).
- Timer: `std::chrono::steady_clock`, nanoseconds.
- Host power mode: **lowest performance/power mode** during the main run
  (reported by the operator).  Absolute times would change in another mode;
  the experiment is paired, so ratios are the primary result.  A subset
  sensitivity check is in `scripts/check_performance_mode.sh`.

## Build and correctness

```text
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j 16
./build/test_core
```

The test suite passed:

- binary heap order;
- hand-computed weighted graph vs Floyd–Warshall;
- hand-checked 5x5 grid (distance 8);
- no-path grid;
- all five 32x32 grid families vs BFS;
- ALT admissibility and consistency;
- tie-break distance equivalence;
- six real-graph queries vs BFS.

An additional AddressSanitizer/UndefinedBehaviorSanitizer build of the test
suite also passed.  The 30-query real validation separately passed:

```text
validation: 30 queries; BFS oracle, Dijkstra and A* distances agree and both paths are valid
```

## Main run

```text
./build/astar_research benchmark-grid \
  --out results/grid.csv --sizes 128,256,512,1024 \
  --families open,random,clustered,rooms,maze \
  --reps 3 --per-band 5 --seed 20261030 --time-limit-s 30

./build/astar_research benchmark-real \
  --graph data/roadNet-CA.bin \
  --landmarks data/roadNet-CA.alt16.bin \
  --out results/real.csv \
  --reps 5 --per-band 10 --main-k 8 --seed 20261030 --time-limit-s 30
```

- Grid: 20 graphs, 300 queries, 3 repeats, 3 treatments -> 2,700 rows.
- Real: 1 graph, 30 queries, 5 repeats, 6 treatments -> 900 rows.
- Total: 3,600 rows; all `status=ok` and `correct=1`; **no timeouts**.
- Wall-clock time for tests + validation + both benchmarks: about **2 min 45 s**
  (`user 160.98 s`).
- Median within-query time CV: grid Dijkstra 7.2%, grid A* 10.1%, real
  Dijkstra 7.4%, real A* K=8 9.6%.
- Expansions were deterministic across repeats (0 of 1,080 query/treatment
  groups had more than one distinct expansion count).

## Analysis

```text
python3 scripts/analyze_results.py
```

Outputs: `results/analysis.md`, `results/summary_*.csv`,
`results/paired_*.csv`, `figures/*.png`.

## Data availability

The large SNAP/filtered graph files are intentionally not shipped so the project
can be archived without 278 MB of generated binaries.  Run `./download_data.sh`
to recreate them.  These are the checksums of the exact files used for the
reported run:

```text
8a0d9cd0c6d71dbe63a1e368acbb891d2cfb76dcb58534627ec6a10f30d814e5  results/grid.csv
a9b2f8bf4ccd8745cf7b3455d3d923cb109632451577abd6c5e043a1483b406e  results/real.csv
383f7b14424530a9e25c392969a9c19dace32ebcfd141f0967a1433498c2acdd  data/roadNet-CA.txt.gz
6446779dc9a374004c9af78b921ef47136e9e19e80c16a5c961f18f67894fddf  data/roadNet-CA.bin
cfba9dbf41b37e3c2e0a4d264f138243d51334fc6d0e10748b9a62f4af5edaf9  data/roadNet-CA.alt16.bin
```

## Post-freeze exploratory runs

These runs were made after the main protocol and are reported separately in
`NOVELTY.md`; they do not replace `results/grid.csv` or `results/real.csv`.

```text
./build/astar_research diagnose-grid \
  --out results/grid_diagnostics.csv --sizes 128,256,512,1024 \
  --families open,random,clustered,rooms,maze --per-band 5 --seed 20261030

./build/astar_research diagnose-real \
  --graph data/roadNet-CA.bin --landmarks data/roadNet-CA.alt16.bin \
  --out results/real_diagnostics.csv --main-k 8 --per-band 10 --seed 20261030

./build/astar_research weighted-maze \
  --out results/weighted_maze.csv --sizes 128,256,512,1024 \
  --per-band 5 --reps 3 --seed 20261030
```

- Grid diagnostics: 300 queries; wall clock 21.7 s; peak RSS 116 MB.
- Real diagnostics: 30 queries; wall clock 17.0 s; peak RSS 317 MB.
- Weighted A*: 1,260 rows (180 Dijkstra + 1,080 weighted), all `status=ok`;
  wall clock 15.6 s; peak RSS 81 MB.
- `epsilon=1` returns the optimal distance on every query; all weighted runs
  return at least the optimal distance.  On the perfect mazes, the returned
  path-cost ratio is exactly 1.00.
- Analysis: `python3 scripts/analyze_novelty.py`.

The host was still in its lowest performance/power mode for these exploratory
runs; all comparisons are paired and within-mode.

## OpenMP batch-throughput run

Separate from the frozen protocol and the query-level study.  The process was
pinned to CPUs 0--15 with `taskset`; OpenMP used `OMP_PROC_BIND=close` and
`OMP_PLACES=cores`; the 4 GiB process cap was applied.

```text
ulimit -v 4194304
OMP_PROC_BIND=close OMP_PLACES=cores taskset -c 0-15 \
  ./build/astar_research omp-scaling \
  --graph data/roadNet-CA.bin --landmarks data/roadNet-CA.alt16.bin \
  --out-batch results/omp_scaling.csv --out-tasks results/omp_tasks.csv \
  --sizes 1024 --threads 1,2,4,8,16 --per-band 5 --reps 3 --batch-reps 3 \
  --seed 20261030
```

- Workload: five `1024x1024` grids (15 queries each, 3 repeats) + 30 road
  queries (3 repeats) = 270 tasks per batch.
- Thread counts: 1, 2, 4, 8, 16; 3 timed batch repetitions plus one warm-up
  per thread count.
- Rows: 90 batch rows, 4,050 task rows; all `status=ok`.
- Wall clock: 5 min 43 s; maximum RSS 1.08 GB.
- Batch time at 1 thread: 44.39 s; at 16 threads: 4.56 s; speedup **9.73x**,
  efficiency 0.61.  Grid-only 9.93x, road-only 9.36x.
- Median per-query latency at 16 threads: Dijkstra 140.8 ms (21% above 1
  thread), A* 6.17 ms (18% above 1 thread).  Median Dijkstra/A* ratio moves
  from 14.8x to 17.9x; the maze remains below parity.
- Analysis: `python3 scripts/analyze_omp.py`.

The host was still in its lowest performance/power mode; all OpenMP timings are
from that mode.  This is a throughput result, not a replacement for the serial
query-level protocol.
