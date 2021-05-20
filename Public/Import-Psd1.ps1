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


    $Psd1Ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$null, [ref]$null)
    if (-not $Psd1Ast)
    {
        Write-Error "Failed to parse '$Path'." -ErrorAction Stop
    }

    # The actual hashtable content; type HashtableAst
    $HashtableAst = $Psd1Ast.EndBlock.Statements[0].PipelineElements[0].Expression

    Parse-HashtableAst $HashtableAst
}
