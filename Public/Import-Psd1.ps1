function Import-Psd1
{
    <#
        .SYNOPSIS
        Imports the content of a .psd1 file as a nested ordered hashtable.

        .PARAMETER Path
        Specify the path to a .psd1 file.

        If the path provided is a directory, this command assumes that the input represents a
        PowerShell module and appends a .psd1 filename of the same name as the module.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )


    $Path = $Path | Resolve-Psd1Path

    Get-Content $Path -Raw | Invoke-Expression
}
