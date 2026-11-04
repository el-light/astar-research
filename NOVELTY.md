# Exploratory extensions: what makes A* win or lose?

These analyses were added **after** the frozen main experiment.  They do not
change the main protocol or its data; they are clearly labelled exploratory in
the report.  Full tables are in `results/novelty.md`, and the C++/Python
pipeline is reproducible with `./scripts/run_novelty.sh`.

## 1. Heuristic informativeness

For every grid query we run reverse BFS from the target and compare the
heuristic with the true remaining distance on 5,000 sampled vertices.  We
measure:

- Spearman correlation between `h(v)` and `d(v,t)`;
- normalised mean absolute error `MAE / mean(d)`;
- detour ratio `BFS distance / Manhattan distance`;
- effective branching factor.

The result is a mechanism, not just a table: admissibility is not enough.  The
normalised heuristic error has a pooled Spearman correlation of **−0.81** with
the Dijkstra/A* time ratio; the correlation feature has **+0.78**.  A simple
one-feature model has **R² = 0.55**.  On the California road network with ALT
K=8, the heuristic–distance correlation is **0.98**, normalised MAE **0.155**,
and absolute error correlates **−0.77** with the time ratio.

The maze is the outlier: correlation 0.42, normalised MAE 0.97, and A* is
slower.  This explains the negative result instead of merely reporting it.

## 2. Price of optimality: weighted A* on mazes

We add weighted A* with `f = g + εh`, reopening closed vertices when a better
`g` is found, and sweep `ε = 1, 2, 5, 10, 20, 50`.

A perfect maze has a **unique simple path**, so every returned path has the
same cost: the measured path-cost ratio is exactly **1.00** for every ε.  That
means the optimality price is zero on this control; the exercise isolates the
search-order effect.

The speed effect is size-dependent:

- `128²`: weighted A* is slower (0.86x at ε=50) because overhead dominates.
- `512²`: 1.20x faster at ε=50.
- `1024²`: **1.68x faster** at ε=50 (p < 1e-4); short queries reach **3.43x**.

So the maze negative result is not the end of the story: if the task has a
unique route, a greedier ordering can recover the speed without changing the
path.  On a graph with several paths, the same ε would trade cost for speed.

## 3. Tie-break tail risk

The existing `larger_g` vs `node_id` comparison is a tail-risk result.  On open
grids the median expansion ratio is 1.00, but **45%** of queries are worse with
`node_id`, **37%** are worse by more than 10x, and the worst is **285.7x**.
`larger_g` never expanded more vertices on the open grid.  This is why the
median alone is misleading for tie-breaking.


## 4. Batch throughput with OpenMP

The search itself is sequential, but independent queries are not.  We run the
five 1024x1024 grid families (15 queries each, 3 repeats) and the 30 road
queries (3 repeats) with 1, 2, 4, 8 and 16 OpenMP threads.  Each task still runs
Dijkstra and A* sequentially on the same query, and each worker gets its own
`SearchScratch` and heuristic object.  The frozen query-level results remain
serial.

| threads | batch time | speedup | efficiency | median Dijkstra | median A* |
|---:|---:|---:|---:|---:|---:|
| 1 | 44.39 s | 1.00x | 1.00 | 116.3 ms | 5.24 ms |
| 2 | 21.48 s | 2.07x | 1.03 | 108.4 ms | 5.51 ms |
| 4 | 10.11 s | 4.39x | 1.10 | 92.2 ms | 5.25 ms |
| 8 | 6.27 s | 7.08x | 0.89 | 112.1 ms | 5.50 ms |
| 16 | 4.56 s | **9.73x** | 0.61 | 140.8 ms | 6.17 ms |

The grid workload scales 9.93x and the road workload 9.36x at 16 threads.
Per-query latency inflates only 21% for Dijkstra and 18% for A* at 16 threads;
the median Dijkstra/A* ratio moves from 14.8x to 17.9x.  The maze remains the
exception (0.87x at 16 threads), so the structural conclusion is unchanged
under parallel load.

The sublinear efficiency is expected: the CPU has a mix of performance and
efficiency cores, and the road workload is memory-heavy.  The efficiencies
slightly above one at two and four threads are within frequency/run-to-run
variation, not super-linear scaling.  This is a throughput result, not a claim
that a single A* query becomes faster.

## Files

- `results/grid_diagnostics.csv` — 300 grid queries, heuristic errors and correlations
- `results/real_diagnostics.csv` — 30 road queries with ALT K=8
- `results/weighted_maze.csv` — 1,260 timed runs (180 Dijkstra + 1,080 weighted A*)
- `results/omp_scaling.csv` — OpenMP batch times
- `results/omp_tasks.csv` — OpenMP per-query latencies
- `results/novelty.md`, `results/omp.md` — generated tables
- `figures/novelty_heuristic_speedup.png`
- `figures/novelty_weighted_maze.png`
- `figures/omp_scaling.png`
- `figures/omp_astar_advantage.png`
