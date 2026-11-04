#!/usr/bin/env python3
"""Run the three analysis scripts on results/replication_macos/.

The analysis scripts hard-code results/ and figures/.  This driver points
their RESULTS and FIGURES globals at the replication folder, so the frozen
outputs of the main run are never overwritten.
"""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "results" / "replication_macos"
FIG = OUT / "figures"


def load(name: str):
    spec = importlib.util.spec_from_file_location(name, ROOT / "scripts" / f"{name}.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module.RESULTS = OUT
    module.FIGURES = FIG
    return module


def main() -> None:
    FIG.mkdir(parents=True, exist_ok=True)
    for name in sys.argv[1:] or ["analyze_results", "analyze_novelty", "analyze_omp"]:
        print(f"--- {name} -> {OUT}")
        load(name).main()


if __name__ == "__main__":
    main()
