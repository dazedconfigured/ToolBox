function New-ModuleStructure {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$ModuleName,

        [Parameter(Mandatory=$true)]
        [string]$RepositoryPath
    )

    # Define the paths for the module and its subdirectories
    $modulePath = Join-Path -Path $RepositoryPath -ChildPath $ModuleName
    $publicPath = Join-Path -Path $modulePath -ChildPath 'Public'
    $privatePath = Join-Path -Path $modulePath -ChildPath 'Private'
    $testsPath = Join-Path -Path $modulePath -ChildPath 'Tests'

    # Create the module folder in the repository folder
    Write-Verbose "Creating module folder at '$modulePath'."
    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null

    # Add 'Public', 'Private', and 'Tests' folders to the module folder
    Write-Verbose "Creating 'Public' folder at '$publicPath'."
    New-Item -ItemType Directory -Path $publicPath -Force | Out-Null

    Write-Verbose "Creating 'Private' folder at '$privatePath'."
    New-Item -ItemType Directory -Path $privatePath -Force | Out-Null

    Write-Verbose "Creating 'Tests' folder at '$testsPath'."
    New-Item -ItemType Directory -Path $testsPath -Force | Out-Null

    # Add a new .psm1 file to the module named the same as the module folder
    $moduleFilePath = Join-Path -Path $modulePath -ChildPath "$ModuleName.psm1"
    Write-Verbose "Creating module file '$moduleFilePath'."
    New-Item -ItemType File -Path $moduleFilePath -Force | Out-Null

    Write-Verbose "Module structure for '$ModuleName' has been created successfully."
}

# Example usage with verbose output:
# New-ModuleStructure -ModuleName 'MyNewModule' -RepositoryPath 'C:\Path\To\Repository' -Verbose
