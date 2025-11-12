# Project Memory

## 2025-11-12: Centralized Logging Refactor

- **Objective**: Create a centralized logging script and refactor existing scripts to use it.
- **Created `scripts/logger.sh`**:
    - Implemented granular logging functions:
        - `log_info`, `log_warn`, `log_error`, `log_success`, `log_debug`, `log_header` for dual (console + file) output.
        - `log_*_console` variants for console-only output.
        - `log_*_file` variants for file-only output.
- **Refactored Scripts**:
    - `4.run-battlenet-launcher.sh` (and symlink `sc2-run-battlenet-launcher.sh`): Updated to use a mix of dual, console-only, and file-only logging functions to preserve original behavior.
    - `0.install-dependances-on-arch-garuda.sh`: Corrected to use console-only logging functions.
    - `0.install-dependances-on-suse-thumbleweed.sh`: Corrected to use console-only logging functions.
    - `1.install-dxvk.sh`: Corrected to use console-only logging functions.
    - `2.install-dxvk-and-battlenet.sh`: Corrected to use console-only logging functions.
    - `3.create-sc2-desktop.sh`: Corrected to use console-only logging functions.
    - `5.run-sc2.sh`: Refactored to use granular console and file logging functions.
- **Outcome**: All relevant scripts now use the centralized `logger.sh`, ensuring consistent logging behavior that respects the original output destinations (console, file, or both).
