# Import the GroupPolicy module
Import-Module GroupPolicy

function Remove-GPPDriveMap {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [string]$gpoGuid = $null,
        [string]$gpoName = $null,
        [string]$driveLetter = $null,
        [string]$drivePath = $null
    )

    try {
        if (-not $gpoGuid -and -not $gpoName) {
            throw "Please provide either -gpoGuid or -gpoName parameter."
        }

        # Load the GPO by GUID or Name
        if ($gpoGuid) {
            $gpo = Get-GPO -Guid $gpoGuid -ErrorAction Stop
        } elseif ($gpoName) {
            $gpo = Get-GPO -Name $gpoName -ErrorAction Stop
        }

        # Load the GPP XML configuration
        $gppXml = $gpo.ExtensionData.GetXml() | Out-String

        # Construct an XPath query for DriveMap elements
        $xpathQuery = "/GPO/ComputerConfiguration/Preferences/DriveMaps/DriveMap"

        # Use XML SelectNodes to filter DriveMap elements based on criteria
        $matchingDriveMaps = $gpo.ExtensionData.SelectNodes($xpathQuery) | Where-Object {
            (!$driveLetter -or $_.Letter -eq $driveLetter) -and
            (!$drivePath -or $_.Path -eq $drivePath)
        }

        if ($matchingDriveMaps.Count -gt 0) {
            foreach ($map in $matchingDriveMaps) {
                if ($PSCmdlet.ShouldProcess("Deleting drive map preference")) {
                    $gpo.ExtensionData.RemoveChild($map)
                }
            }

            if ($PSCmdlet.ShouldProcess("Saving changes to the GPO")) {
                # Save the changes to the GPO
                $gpo.Save()
            }

            Write-Host "Drive map preference(s) deleted successfully."
        } else {
            throw "No matching drive map preference found."
        }
    } catch {
        Write-Host "An error occurred: $_"
    }
}
