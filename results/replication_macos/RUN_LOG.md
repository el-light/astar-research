# Replication run (macOS)

Date: 2026-11-04.  Same code, same seeds and the same commands as the frozen
run in `results/RUN_LOG.md`; outputs written here only.  The frozen
`results/*.csv`, `results/*.md` and `figures/*.png` were not modified.

## Environment

- CPU: Apple M4 Pro, 12 cores; 24 GiB RAM.
- OS: macOS 27.0.1.
- Compiler: Apple Clang 21.0.0 (libc++), C++20, CMake 4.3.1, Release.
- OpenMP: Homebrew libomp (`-DOpenMP_ROOT=/opt/homebrew/opt/libomp`).
- No `taskset` (not available on macOS) and no `ulimit -v`; otherwise the
  commands match `scripts/run_experiments.sh`, `run_novelty.sh`, `run_omp.sh`.
- Script: `scripts/run_replication_macos.sh`; analysis:
  `scripts/analyze_replication.py`.

## Data and correctness

The downloaded and preprocessed files are byte-identical to the frozen run
(same SHA-256 as `results/RUN_LOG.md`):

```text
383f7b14424530a9e25c392969a9c19dace32ebcfd141f0967a1433498c2acdd  data/roadNet-CA.txt.gz
6446779dc9a374004c9af78b921ef47136e9e19e80c16a5c961f18f67894fddf  data/roadNet-CA.bin
cfba9dbf41b37e3c2e0a4d264f138243d51334fc6d0e10748b9a62f4af5edaf9  data/roadNet-CA.alt16.bin
```

- `test_core`: all tests passed, including the real-graph sample (6 queries).
- `validate-real`: 30 queries; BFS, Dijkstra and A* agree; both paths valid.
- Main benchmarks: 3,600 rows, all `status=ok` and `correct=1`; no timeouts.

## Why the numbers are a new sample, not a copy

`std::mt19937_64` is fully specified, but `uniform_int_distribution`,
`bernoulli_distribution`, `uniform_real_distribution`, `std::shuffle` and
`std::sample` are implementation-defined.  libc++ and libstdc++ therefore turn
the same seeds into different clustered, rooms and maze grids and different
query pairs.  The road graph and landmarks contain no such calls and are
identical.  The replication is an independent draw from the same design.

## Wall-clock time

| step | seconds |
|---|---:|
| download + preprocess | 23.5 |
| validate-real | 4.7 |
| benchmark-grid | 14.3 |
| benchmark-real | 44.3 |
| diagnose-grid / diagnose-real / weighted-maze | 6.4 / 6.1 / 4.0 |
| omp-scaling (1, 2, 4, 8, 12 threads) | 136.4 |

## Main results: original vs replication

Ratio = Dijkstra / A*, median of per-query medians.

| graph | time, original | time, replication | expansions, original | expansions, replication |
|---|---:|---:|---:|---:|
| open | 105.7x | 208.8x | 222.4x | 256.8x |
| random 20% | 12.8x | 15.6x | 21.4x | 22.2x |
| clustered 30% | 12.8x | 12.5x | 22.9x | 20.8x |
| rooms | 8.7x | 8.6x | 14.3x | 12.9x |
| maze | 0.81x | 0.79x | 1.02x | 1.01x |
| roads, ALT K=1 | 1.29x (p=0.13) | 1.41x (p=0.007) | 1.96x | 2.28x |
| roads, ALT K=4 | 4.75x | 7.93x | 7.27x | 11.2x |
| roads, ALT K=8 | 7.62x | 10.56x | 11.5x | 14.6x |
| roads, ALT K=16 | 13.5x | 15.0x | 22.4x | 24.1x |

One A* expansion costs 1.33-1.59x a Dijkstra expansion on the M4 Pro
(1.21-2.03x originally), which is why the open-grid time ratio is higher.

## What held and what did not

Held on both machines:

- the ordering open > random, clustered > rooms > maze, and the maze slowdown
  (A* faster on 0 of 60 maze queries here, 10 of 60 originally);
- more landmarks always better, with no plateau at K=16;
- heuristic error vs speed-up: Spearman -0.83 here, -0.81 originally;
- OpenMP: 7.18x at 12 threads (efficiency 0.60); the Dijkstra/A* ratio stays
  stable under load (14.6x -> 15.4x).

Did not hold, so it should not be claimed as a finding:

- H5 distance bands: random long 26.8x vs short 20.9x expansions here
  (originally long < short); roads K=8 time ratio short 10.0x, medium 9.8x,
  long 13.2x here (originally 14.9x, 9.4x, 4.3x);
- weighted A* at 128^2: 1.14x faster at epsilon=50 here (0.86x originally);
- H3 per size: rooms beat random at 1024^2 here (32.7x vs 12.7x), at 512^2
  originally; the pooled comparison holds on both;
- H7 median: node_id/larger_g median is 35.8x here vs 1.00 originally.

H7 explanation (checked on both runs): `node_id` prefers smaller cell ids,
i.e. upper rows.  When the target is below the source it expands more on
72 of 73 queries; when the target is above or level it never does
(0 of 47).  The median only reflects the share of below-targets in the
sample: 47% originally, 75% here.
