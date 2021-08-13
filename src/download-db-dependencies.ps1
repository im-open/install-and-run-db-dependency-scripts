param(
    [PSCustomObject[]]$dependencies
)

if ($null -eq $dependencies -or !$dependencies.PSobject.Properties.name.Contains("Count" ) -or $dependencies.Count -eq 0)
{
    return
}

Write-Host "Downloading database objects"

$nugetFolder = "$PSScriptRoot\.nuget"
$dependencyOutputFolder = "$PSScriptRoot\.dependencies"
$targetNugetExe = "$nugetFolder\nuget.exe"
$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

if (![System.IO.File]::Exists($targetNugetExe))
{
    Write-Host "Downloading nuget.exe"
    New-Item -ItemType Directory -Path $nugetFolder
    Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
}

if (-Not (Test-Path $dependencyOutputFolder))
{
    New-Item -ItemType Directory -Path $dependencyOutputFolder
}

foreach ($dependency in $dependencies)
{
    #Download Package
    $packageName = $dependency.packageName
    $version = $dependency.version
    $url = $dependency.nugetUrl
    $nugetOutput = "$dependencyOutputFolder\$packageName.nupkg"
    Write-Host "Downloading $packageName.$version"
    Remove-Item $nugetOutput -Force -Recurse -ErrorAction Ignore

    try
    {
        Invoke-WebRequest $url -OutFile $nugetOutput
    }
    catch
    {
        Write-Error $_;
    }

    #Extract Package
    $extractionLocation = "$dependencyOutputFolder\$packageName"
    Remove-Item $extractionLocation -Force -Recurse -ErrorAction Ignore
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($nugetOutput, $extractionLocation)
}

Write-Host "Finished downloading database objects"