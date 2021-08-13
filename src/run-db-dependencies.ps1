param (
    [string]$dbServer,
    [string]$dbName
)

Write-Host "Running database dependency scripts"

$dependencyFolder = "$PSScriptRoot\.dependencies"

Import-Module SqlServer

Get-ChildItem -Path $dependencyFolder -Recurse -Depth 1 -Filter *.sql | ForEach-Object {
    Write-Host "Running $($_.Name)"
    Invoke-Sqlcmd -InputFile $_.FullName -ServerInstance $dbServer -Database $dbName -AbortOnError -SeverityLevel 0 -ErrorLevel 0 -Verbose
}

Write-Host "Finished running database dependency scripts"