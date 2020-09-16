# ---------------------------------------------------------------------------------------------------------------------
# RUN TERRAGRUNT PLAN-ALL, OUTPUT THE PLAN TO THE TERMINAL AND TO A LOG FILE
# ---------------------------------------------------------------------------------------------------------------------

#!/usr/bin/env bash
set -euo pipefail

LOG_FILE_NAME=${1:-plan.log}

# Run plan all and display output both to terminal and the log file temp.log
terragrunt plan-all --terragrunt-working-dir live 2>&1 | tee temp.log

# Remove bash colors from log file and put the output into the new log file
sed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" temp.log > ${LOG_FILE_NAME}
