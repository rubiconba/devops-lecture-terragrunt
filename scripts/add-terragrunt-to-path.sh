# ---------------------------------------------------------------------------------------------------------------------
# THIS SCRIPT WILL ADD THE TERRAGRUNT BINARY TO PATH
# ---------------------------------------------------------------------------------------------------------------------

#!/usr/bin/env bash
set -euo pipefail

# Open the folder where terragrunt is downloaded
WORKING_DIRECTORY=${1}
cd ${WORKING_DIRECTORY}

# Copy the file to /usr/local/bin so we don't have to specify the full path
sudo cp -a terragrunt /usr/local/bin

# Make the file executable
chmod +x /usr/local/bin/terragrunt

# Test if it works, by printing out the version of terragrunt
terragrunt --version