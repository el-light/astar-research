# Generated analysis
All tables use per-query medians over repeated runs and paired
Dijkstra/A* comparisons.  Ratio = Dijkstra / A*; values above 1 mean
A* wins.  Time is wall-clock time around the search call.

## Correctness

Rows: 3600; non-ok/incorrect rows: 0.

## Grid: main treatment (Manhattan, larger_g)

| family | n_pairs | time_ratio_median | time_ratio_q1 | time_ratio_q3 | exp_ratio_median | exp_ratio_q1 | exp_ratio_q3 | time_saving_pct_median | exp_saving_pct_median | a_faster_fraction | a_fewer_fraction | ns_per_exp_d_median | ns_per_exp_a_median | time_ratio_over_exp_ratio |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| clustered | 60.00 | 12.54 | 7.10 | 37.90 | 20.75 | 10.99 | 55.97 | 92.03 | 95.18 | 0.98 | 1.00 | 57.40 | 90.74 | 0.65 |
| maze | 60.00 | 0.79 | 0.75 | 0.86 | 1.01 | 1.00 | 1.05 | -26.08 | 1.24 | 0.00 | 0.97 | 19.55 | 26.05 | 0.76 |
| open | 60.00 | 208.82 | 87.59 | 280.64 | 256.76 | 109.25 | 439.42 | 99.52 | 99.61 | 1.00 | 1.00 | 62.31 | 82.76 | 0.73 |
| random | 60.00 | 15.60 | 8.73 | 25.21 | 22.24 | 12.71 | 36.40 | 93.59 | 95.50 | 1.00 | 1.00 | 66.97 | 98.90 | 0.67 |
| rooms | 60.00 | 8.62 | 4.46 | 20.35 | 12.92 | 8.43 | 29.56 | 88.39 | 92.26 | 0.98 | 1.00 | 64.32 | 102.36 | 0.62 |

## Grid by family and size

| family | size | n_pairs | time_ratio_median | exp_ratio_median | a_faster_fraction | time_ms_d_median | time_ms_a_median |
|---|---|---|---|---|---|---|---|
| clustered | 128 | 15.00 | 7.19 | 10.51 | 1.00 | 0.32 | 0.03 |
| clustered | 256 | 15.00 | 8.40 | 14.89 | 0.93 | 1.29 | 0.12 |
| clustered | 512 | 15.00 | 48.90 | 60.77 | 1.00 | 7.14 | 0.11 |
| clustered | 1024 | 15.00 | 22.87 | 33.89 | 1.00 | 34.13 | 2.38 |
| maze | 128 | 15.00 | 0.76 | 1.03 | 0.00 | 0.06 | 0.08 |
| maze | 256 | 15.00 | 0.78 | 1.03 | 0.00 | 0.29 | 0.36 |
| maze | 512 | 15.00 | 0.79 | 1.01 | 0.00 | 1.65 | 2.07 |
| maze | 1024 | 15.00 | 0.86 | 1.01 | 0.00 | 7.17 | 7.76 |
| open | 128 | 15.00 | 58.28 | 90.28 | 1.00 | 0.57 | 0.01 |
| open | 256 | 15.00 | 131.63 | 186.52 | 1.00 | 2.43 | 0.01 |
| open | 512 | 15.00 | 231.31 | 406.94 | 1.00 | 10.74 | 0.04 |
| open | 1024 | 15.00 | 349.11 | 640.98 | 1.00 | 48.58 | 0.09 |
| random | 128 | 15.00 | 17.74 | 24.37 | 1.00 | 0.42 | 0.02 |
| random | 256 | 15.00 | 15.83 | 23.16 | 1.00 | 1.97 | 0.11 |
| random | 512 | 15.00 | 16.07 | 22.92 | 1.00 | 8.79 | 0.22 |
| random | 1024 | 15.00 | 9.00 | 12.65 | 1.00 | 46.56 | 3.38 |
| rooms | 128 | 15.00 | 4.48 | 8.03 | 0.93 | 0.39 | 0.05 |
| rooms | 256 | 15.00 | 6.44 | 10.38 | 1.00 | 2.06 | 0.33 |
| rooms | 512 | 15.00 | 12.51 | 13.76 | 1.00 | 8.06 | 0.32 |
| rooms | 1024 | 15.00 | 23.44 | 32.69 | 1.00 | 48.89 | 1.73 |

## Grid by family and distance band

| family | band | n_pairs | time_ratio_median | exp_ratio_median | a_faster_fraction |
|---|---|---|---|---|---|
| clustered | long | 20.00 | 7.81 | 13.65 | 0.95 |
| clustered | medium | 20.00 | 9.12 | 18.54 | 1.00 |
| clustered | short | 20.00 | 39.51 | 58.00 | 1.00 |
| maze | long | 20.00 | 0.76 | 1.00 | 0.00 |
| maze | medium | 20.00 | 0.78 | 1.01 | 0.00 |
| maze | short | 20.00 | 0.81 | 1.06 | 0.00 |
| open | long | 20.00 | 208.82 | 305.66 | 1.00 |
| open | medium | 20.00 | 227.46 | 298.14 | 1.00 |
| open | short | 20.00 | 147.85 | 191.55 | 1.00 |
| random | long | 20.00 | 17.84 | 26.75 | 1.00 |
| random | medium | 20.00 | 12.75 | 19.89 | 1.00 |
| random | short | 20.00 | 15.88 | 20.94 | 1.00 |
| rooms | long | 20.00 | 10.52 | 18.03 | 0.95 |
| rooms | medium | 20.00 | 5.76 | 9.73 | 1.00 |
| rooms | short | 20.00 | 12.19 | 14.41 | 1.00 |

## Tie-break (node_id / larger_g)

| family | exp_ratio_nodeid_over_largerg_median | exp_ratio_nodeid_over_largerg_q1 | exp_ratio_nodeid_over_largerg_q3 | time_ratio_nodeid_over_largerg_median | time_ratio_nodeid_over_largerg_q1 | time_ratio_nodeid_over_largerg_q3 |
|---|---|---|---|---|---|---|
| clustered | 1.07 | 1.00 | 5.57 | 0.99 | 0.87 | 3.64 |
| maze | 1.00 | 1.00 | 1.00 | 0.95 | 0.92 | 0.97 |
| open | 35.78 | 5.28 | 89.31 | 22.39 | 3.83 | 56.40 |
| random | 1.02 | 1.00 | 1.54 | 1.06 | 0.97 | 1.30 |
| rooms | 1.03 | 1.00 | 1.29 | 0.96 | 0.88 | 1.07 |

## Real graph

| band | variant | n_pairs | time_ratio_median | time_ratio_q1 | time_ratio_q3 | exp_ratio_median | exp_ratio_q1 | exp_ratio_q3 | a_faster_fraction | time_ms_d_median | time_ms_a_median |
|---|---|---|---|---|---|---|---|---|---|---|---|
| long | astar_alt1 | 10.00 | 1.30 | 0.91 | 1.80 | 2.19 | 1.42 | 2.83 | 0.60 | 217.63 | 168.64 |
| long | astar_alt16 | 10.00 | 13.89 | 8.81 | 19.86 | 22.49 | 14.83 | 29.90 | 1.00 | 217.63 | 15.83 |
| long | astar_alt4 | 10.00 | 11.40 | 4.25 | 14.42 | 18.09 | 6.50 | 20.41 | 1.00 | 217.63 | 18.99 |
| long | astar_alt8 | 10.00 | 13.16 | 5.69 | 17.43 | 20.50 | 8.87 | 24.89 | 1.00 | 217.63 | 16.51 |
| medium | astar_alt1 | 10.00 | 1.37 | 1.05 | 1.61 | 2.09 | 1.60 | 2.40 | 0.80 | 139.07 | 93.41 |
| medium | astar_alt16 | 10.00 | 29.86 | 15.52 | 40.94 | 44.44 | 23.49 | 59.58 | 1.00 | 139.07 | 4.10 |
| medium | astar_alt4 | 10.00 | 7.28 | 4.23 | 14.33 | 10.49 | 6.48 | 20.54 | 1.00 | 139.07 | 16.20 |
| medium | astar_alt8 | 10.00 | 9.75 | 7.57 | 23.56 | 13.88 | 11.41 | 30.71 | 1.00 | 139.07 | 10.52 |
| short | astar_alt1 | 10.00 | 1.76 | 1.31 | 2.04 | 2.53 | 2.04 | 3.10 | 1.00 | 18.64 | 8.31 |
| short | astar_alt16 | 10.00 | 11.97 | 7.35 | 21.22 | 17.71 | 11.27 | 31.52 | 1.00 | 18.64 | 1.01 |
| short | astar_alt4 | 10.00 | 6.74 | 4.17 | 9.32 | 9.97 | 6.02 | 13.50 | 1.00 | 18.64 | 1.78 |
| short | astar_alt8 | 10.00 | 9.97 | 7.14 | 16.65 | 14.18 | 10.78 | 25.06 | 1.00 | 18.64 | 1.03 |

## Real graph by K

| variant | n_pairs | time_ratio_median | exp_ratio_median | time_saving_pct_median | exp_saving_pct_median | a_faster_fraction |
|---|---|---|---|---|---|---|
| astar_alt1 | 30.00 | 1.41 | 2.28 | 28.87 | 56.06 | 0.80 |
| astar_alt16 | 30.00 | 15.03 | 24.06 | 93.32 | 95.84 | 1.00 |
| astar_alt4 | 30.00 | 7.92 | 11.21 | 87.24 | 91.07 | 1.00 |
| astar_alt8 | 30.00 | 10.56 | 14.57 | 90.49 | 93.13 | 1.00 |

## Figures

![Grid ratios](../figures/grid_ratios_by_family.png)

![Time vs expansions](../figures/grid_time_vs_expansion.png)

![Scaling](../figures/grid_scaling.png)

![Tie-break](../figures/grid_tie_break.png)

![Real graph](../figures/real_ratios_by_band_k.png)

