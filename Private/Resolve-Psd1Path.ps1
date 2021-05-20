function Resolve-Psd1Path
{
    <#
        .SYNOPSIS
        Resolves the path to a .psd1 file.

        .PARAMETER Path
        Specify the path to a .psd1 file.

        If the path provided is a directory, this command assumes that the input represents a
        PowerShell module and appends a .psd1 filename of the same name as the module.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string]$Path
    )

    process
    {
        $Path = (Resolve-Path $Path -ErrorAction Stop).Path

        if (Test-Path $Path -PathType Container)
        {
            $Container = Split-Path $Path -Leaf
            if ([version]::TryParse($Container, [ref]$null))
            {
                $Container = Split-Path $Path | Split-Path $Path -Leaf
            }
            $Path = Join-Path $Path "$Container.psd1"
        }

        $Path = (Resolve-Path $Path -ErrorAction Stop).Path


        $Path
    }
}
