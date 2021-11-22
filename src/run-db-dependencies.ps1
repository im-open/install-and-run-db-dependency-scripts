param (
    [string]$dbServer,
    [string]$dbName,
    [string]$username,
    [securestring]$password
)

Write-Host "Running database dependency scripts"

$dependencyFolder = "$PSScriptRoot\.dependencies"

Import-Module SqlServer

$sqlCmdParams = @(
    "-ServerInstance `"$dbServer`""
    "-Database `"$dbName`""
    "-AbortOnError"
    "-SeverityLevel 0"
    "-ErrorLevel 0"
    "-Verbose"
)

$temp2 = [string]::Join(" ", $sqlCmdParams)
$temp = @("Invoke-Sqlcmd $temp2")

Write-Host $temp

if ($null -ne $username) {
    $sqlCmdParams += "-Username $username"
}

if ($null -ne $password) {
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password
    $plainPassword = $cred.GetNetworkCredential().Password

    $sqlCmdParams += "-Password $plainPassword"
}

Get-ChildItem -Path $dependencyFolder -Recurse -Depth 1 -Filter *.sql | ForEach-Object {
    Write-Host "Running $($_.Name)"

    $dependencyFileParams = @("-InputFile $($_.FullName)") + $sqlCmdParams
    $paramsAsAString = [string]::Join(" ", $dependencyFileParams)

    Invoke-Expression -Command "Invoke-Sqlcmd $paramsAsAString"
    # Invoke-Sqlcmd `
    #     -InputFile $_.FullName `
    #     -ServerInstance $dbServer `
    #     -Database $dbName `
    #     -Username $username `
    #     -Password $password `
    #     -AbortOnError `
    #     -SeverityLevel 0 `
    #     -ErrorLevel 0 `
    #     -Verbose
}

Write-Host "Finished running database dependency scripts"