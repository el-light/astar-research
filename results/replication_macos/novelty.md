# Novelty analysis

## Heuristic informativeness

| family | n | h_corr | h_nmae | h_mae | detour | time_ratio | exp_ratio | ebf_a |
|---|---|---|---|---|---|---|---|---|
| clustered | 60 | 0.97 | 0.06 | 14.43 | 1.00 | 12.54 | 20.75 | 1.01 |
| maze | 60 | 0.55 | 0.97 | 7913.05 | 23.14 | 0.79 | 1.01 | 1.00 |
| open | 60 | 1.00 | 0.00 | 0.00 | 1.00 | 208.82 | 256.76 | 1.00 |
| random | 60 | 1.00 | 0.02 | 5.24 | 1.00 | 15.60 | 22.24 | 1.01 |
| rooms | 60 | 0.99 | 0.06 | 15.57 | 1.02 | 8.62 | 12.92 | 1.02 |

Spearman correlations with time ratio:

| feature | spearman_vs_time_ratio |
|---|---|
| h_corr | 0.80 |
| h_pearson | 0.80 |
| h_nmae | -0.83 |
| h_rmse | -0.73 |
| detour | -0.83 |
| ebf_a | -0.37 |

Simple explanatory models:

| model | r2 | intercept | slope |
|---|---|---|---|
| log(time_ratio) ~ h_corr | 0.429 | -2.052 | 5.241 |
| log(time_ratio) ~ h_nmae | 0.572 | 3.438 | -3.945 |
| log(time_ratio) ~ detour | 0.222 | 2.900 | -0.043 |

![Heuristic informativeness](../figures/novelty_heuristic_speedup.png)

## Real road network

| n | h_corr | h_nmae | h_mae | time_ratio | exp_ratio |
|---|---|---|---|---|---|
| 30.000 | 0.985 | 0.154 | 46.485 | 10.559 | 14.566 |

| band | n | h_corr | h_nmae | h_mae | time_ratio | exp_ratio |
|---|---|---|---|---|---|---|
| long | 10 | 0.99 | 0.10 | 44.27 | 13.16 | 20.50 |
| medium | 10 | 0.98 | 0.18 | 56.71 | 9.75 | 13.88 |
| short | 10 | 0.98 | 0.16 | 49.28 | 9.97 | 14.18 |

Spearman correlations with time ratio:

| feature | spearman_vs_time_ratio |
|---|---|
| h_corr | 0.48 |
| h_nmae | -0.60 |
| h_mae | -0.58 |

## Weighted A* on perfect mazes

| epsilon | n | time_ratio | time_q1 | time_q3 | cost_ratio | cost_max | exp_ratio | expanded |
|---|---|---|---|---|---|---|---|---|
| 1.00 | 60.00 | 0.83 | 0.77 | 0.93 | 1.00 | 1.00 | 1.01 | 25047.00 |
| 2.00 | 60.00 | 0.89 | 0.78 | 0.96 | 1.00 | 1.00 | 1.04 | 24623.50 |
| 5.00 | 60.00 | 1.03 | 0.90 | 1.17 | 1.00 | 1.00 | 1.11 | 22960.00 |
| 10.00 | 60.00 | 1.12 | 1.00 | 1.34 | 1.00 | 1.00 | 1.22 | 19270.00 |
| 20.00 | 60.00 | 1.20 | 1.02 | 1.45 | 1.00 | 1.00 | 1.29 | 18455.00 |
| 50.00 | 60.00 | 1.22 | 0.97 | 1.61 | 1.00 | 1.00 | 1.34 | 17949.50 |

Time ratio by size:

| size | 1.0 | 2.0 | 5.0 | 10.0 | 20.0 | 50.0 |
|---|---|---|---|---|---|---|
| 128.00 | 0.75 | 0.76 | 0.88 | 1.03 | 1.15 | 1.14 |
| 256.00 | 0.78 | 0.82 | 0.94 | 1.23 | 1.25 | 1.16 |
| 512.00 | 0.83 | 0.90 | 1.08 | 1.23 | 1.23 | 1.32 |
| 1024.00 | 0.94 | 0.96 | 1.06 | 1.13 | 1.17 | 1.26 |

Paired Wilcoxon tests for the larger epsilon values:

| epsilon | size | n | time_ratio_median | wilcoxon_p |
|---|---|---|---|---|
| 10.00 | 128.00 | 15.00 | 1.03 | 0.68 |
| 10.00 | 256.00 | 15.00 | 1.23 | 0.01 |
| 10.00 | 512.00 | 15.00 | 1.23 | 0.02 |
| 10.00 | 1024.00 | 15.00 | 1.13 | 0.00 |
| 20.00 | 128.00 | 15.00 | 1.15 | 0.15 |
| 20.00 | 256.00 | 15.00 | 1.25 | 0.00 |
| 20.00 | 512.00 | 15.00 | 1.23 | 0.00 |
| 20.00 | 1024.00 | 15.00 | 1.17 | 0.00 |
| 50.00 | 128.00 | 15.00 | 1.14 | 0.25 |
| 50.00 | 256.00 | 15.00 | 1.16 | 0.01 |
| 50.00 | 512.00 | 15.00 | 1.32 | 0.01 |
| 50.00 | 1024.00 | 15.00 | 1.26 | 0.01 |

![Weighted A*](../figures/novelty_weighted_maze.png)

The path-cost ratio is 1.0 for every epsilon: a perfect maze has a
unique simple source-target path, so weighted A* cannot return a
different path.  Large epsilon changes the search order and can reduce
expansions, especially for short queries in large mazes.

## Tie-break tail

| family | n | median | q90 | q95 | max | fraction_gt_2 | fraction_gt_10 |
|---|---|---|---|---|---|---|---|
| clustered | 60 | 1.07 | 17.71 | 21.01 | 46.24 | 0.32 | 0.15 |
| maze | 60 | 1.00 | 1.00 | 1.00 | 1.01 | 0.00 | 0.00 |
| open | 60 | 35.78 | 187.67 | 333.19 | 398.72 | 0.75 | 0.72 |
| random | 60 | 1.02 | 7.47 | 14.44 | 32.20 | 0.23 | 0.07 |
| rooms | 60 | 1.03 | 2.86 | 8.31 | 13.41 | 0.17 | 0.02 |

