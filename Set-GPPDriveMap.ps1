# Import the GroupPolicy module
Import-Module GroupPolicy

function Set-GPPDriveMap {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [string]$gpoGuid = $null,
        [string]$gpoName = $null,
        [string]$driveLetter = $null,
        [string]$drivePath = $null,
        [string]$newDriveLetter = $null,
        [string]$newDrivePath = $null,
        [string]$newDriveAction = $null
    )

    try {
        if (-not $gpoGuid -and -not $gpoName) {
            throw "Please provide either -gpoGuid or -gpoName parameter."
        }

        # Check if any of the $new parameters are provided
        if (-not $newDriveLetter -and -not $newDrivePath -and -not $newDriveAction) {
            throw "Please provide at least one of the -new parameters: newDriveLetter, newDrivePath, newDriveAction."
        }

        # Load the GPO by GUID or Name
        if ($gpoGuid) {
            $gpo = Get-GPO -Guid $gpoGuid -ErrorAction Stop
        } elseif ($gpoName) {
            $gpo = Get-GPO -Name $gpoName -ErrorAction Stop
        }

        # Load the GPP XML configuration
        $gppXml = $gpo.ExtensionData.GetXml()

        # Find the DriveMap element with specified DriveLetter and DrivePath
        $driveMap = $gppXml.SelectSingleNode("/GPO/ComputerConfiguration/Preferences/DriveMaps/DriveMap[Letter='$driveLetter'][Path='$drivePath']")

        if ($driveMap) {
            # Update the specified parameters if provided
            if ($newDriveLetter) {
                $driveMap.Letter = $newDriveLetter
            }
            if ($newDrivePath) {
                $driveMap.Path = $newDrivePath
            }
            if ($newDriveAction) {
                $driveMap.Action = $newDriveAction
            }

            # Save the changes back to the GPO
            $gpo.ExtensionData.LoadXml($gppXml.OuterXml)

            if ($PSCmdlet.ShouldProcess("Drive map preference modification")) {
                $gpo.Save()
                Write-Host "Drive map preference modified successfully."
            }
        } else {
            throw "No matching drive map preference found."
        }
    } catch {
        Write-Host "Error: $_"
    }
}
