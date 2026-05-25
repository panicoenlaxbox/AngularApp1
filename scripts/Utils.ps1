<#
.SYNOPSIS
    Wrapper around the az CLI that stops script execution on failure.

.DESCRIPTION
    Azure CLI does not throw PowerShell exceptions — errors must be detected via $LASTEXITCODE.
    This function invokes az with the provided arguments and exits with the same code if the
    command fails, preventing the script from continuing silently after an error.

    See: https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-powershell#error-handling-for-azure-cli-in-powershell

.EXAMPLE
    Invoke-Az group create --name my-rg --location eastus

.EXAMPLE
    $Value = Invoke-Az resource show --query "someProperty" -o tsv
#>
function Invoke-Az {
    az @args
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
