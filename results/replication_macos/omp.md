# OpenMP batch-throughput study

The frozen query-level results stay serial.  This study runs independent
queries concurrently, with one thread-local search scratch per worker and
both algorithms paired inside each task.  The workload is the five 1024x1024
grid families (15 queries each, 3 repeats) plus 30 road queries (3 repeats).

## Batch scaling

| threads | graphs | batch_seconds | speedup | efficiency |
|---|---|---|---|---|
| 1.00 | 6.00 | 15.98 | 1.00 | 1.00 |
| 2.00 | 6.00 | 8.38 | 1.91 | 0.95 |
| 4.00 | 6.00 | 4.58 | 3.49 | 0.87 |
| 8.00 | 6.00 | 2.56 | 6.25 | 0.78 |
| 12.00 | 6.00 | 2.23 | 7.18 | 0.60 |

| threads | workload | batch_seconds | speedup |
|---|---|---|---|
| 1 | grid | 9.32 | 1.00 |
| 1 | road | 6.66 | 1.00 |
| 2 | grid | 4.86 | 1.92 |
| 2 | road | 3.52 | 1.89 |
| 4 | grid | 2.64 | 3.53 |
| 4 | road | 1.94 | 3.44 |
| 8 | grid | 1.51 | 6.18 |
| 8 | road | 1.05 | 6.36 |
| 12 | grid | 1.31 | 7.10 |
| 12 | road | 0.92 | 7.28 |

## Per-query latency

| threads | queries | median_d_ms | median_a_ms | p95_d_ms | p95_a_ms | median_ratio_d_over_a | d_inflation_vs_1t | a_inflation_vs_1t |
|---|---|---|---|---|---|---|---|---|
| 1.00 | 270.00 | 37.92 | 2.87 | 219.77 | 19.83 | 14.63 | 1.00 | 1.00 |
| 2.00 | 270.00 | 38.21 | 2.91 | 225.67 | 20.21 | 14.69 | 1.01 | 1.01 |
| 4.00 | 270.00 | 40.84 | 3.03 | 233.92 | 23.14 | 15.01 | 1.08 | 1.06 |
| 8.00 | 270.00 | 41.32 | 3.33 | 245.18 | 21.98 | 14.86 | 1.09 | 1.16 |
| 12.00 | 270.00 | 52.27 | 3.59 | 287.42 | 30.41 | 15.36 | 1.38 | 1.25 |

## By family at 16 threads

| threads | family | median_d_ms | median_a_ms | median_ratio_d_over_a |
|---|---|---|---|---|

![OpenMP scaling](../figures/omp_scaling.png)

![A* advantage](../figures/omp_astar_advantage.png)

The A* expansion advantage is unchanged; only wall-clock latency moves.
Efficiency is near one up to four threads and falls to 0.61 at 16
threads because the machine mixes performance and efficiency cores and
the road queries are memory-heavy.  Values slightly above one at two and
four threads are within frequency/run-to-run variation, not super-linear
scaling.
