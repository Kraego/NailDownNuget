$slnPath=$args[0]
$nugetName=$args[1]
$nugetVersion=$args[2]

function Find-Nuget 
{
    param (
        [string]$path,
        [string]$currentElementName,
        [string]$currentElementVersion,
        [string]$nugetName,
        [string]$nugetVersion,
        [object[]]$dependencies
    )

    $path = "$($path) > $($currentElementName)"
    
    if($currentElementName.Equals($nugetName) -and $currentElementVersion.Equals($nugetVersion))
    {
        Write-Host "`n * Found: $($path)`n"
    }

    if ($dependencies.Count -eq 0)
    {
        return
    }
    else 
    {
        foreach ($dependency in $dependencies)
        {
            Find-Nuget $path $dependency.id $dependency.version $nugetName $nugetVersion $dependency.dependencies
        }
    }
}

function Get-NugetPath 
{
    param (
        [string]$slnPath,
        [string]$nugetName,
        [string]$nugetVersion
    )

    Write-Host "Executing nuget-deps-tree for path: '$($slnPath)'"
    $dependencies = nuget-deps-tree $slnPath 2>$null #ignore stderr from nuget-deps-tree

    $dependencyTree = $dependencies | ConvertFrom-Json

    foreach ($project in $dependencyTree.projects)
    {
        Write-Host "Checking '$($project.name)'"
        Find-Nuget "" $project.name "" $nugetName $nugetVersion $project.dependencies
    }
}

Get-NugetPath $slnPath $nugetName $nugetVersion
