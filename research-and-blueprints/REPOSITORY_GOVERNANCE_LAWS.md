# IGI Engineering Specification: Repository Governance & Modification Laws

This document dictates the hard operational constraints applied to all commercial repository branches to ensure continuous code stability.

## 1. Branch Protection Laws
*   **Constraint:** Direct pushes to the `main` branch are strictly blocked. 
*   **Execution:** All system modifications must occur via isolated feature branches (`feature/`). A mandatory automated pre-flight script (`verify_alignment.py`) must pass with zero exceptions before a pull request can be merged.

## 2. The 1.0-Delta Constraint
*   **Constraint:** Any proposed alteration to systemic operational variables must be proven to adhere to a strict 1.0-velocity step limit per processing cycle.
*   **Objective:** Prevents inertial computing lag and memory overflows across high-throughput wide-area networks.
