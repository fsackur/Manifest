function ConvertFrom-ExpressionAst
{
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [System.Management.Automation.Language.ExpressionAst]$ExpressionAst
    )


    process
    {
        if ($null -eq $ExpressionAst)
        {
            return
        }

        switch ($ExpressionAst.GetType())
        {
            ([System.Management.Automation.Language.StringConstantExpressionAst])
            {
                $Value = $ExpressionAst.Value
                foreach ($Property in $ExpressionAst.Extent.PSObject.Properties)
                {
                    $Value | Add-Member NoteProperty $Property.Name $Property.Value -Force
                }
                return $Value
            }

            ([System.Management.Automation.Language.ArrayLiteralAst])
            {
                Write-Output @($ExpressionAst.Elements | ConvertFrom-ExpressionAst) -NoEnumerate
                return
            }

            ([System.Management.Automation.Language.ArrayExpressionAst])
            {
                $SubExprAst = $ExpressionAst.SubExpression.Statements.PipelineElements.Expression
                Write-Output @($SubExprAst | ConvertFrom-ExpressionAst) -NoEnumerate
                return
            }

            ([System.Management.Automation.Language.HashtableAst])
            {
                $Output = [ordered]@{}

                $KvpTuples = $ExpressionAst.KeyValuePairs
                foreach ($KvpTuple in $KvpTuples)
                {
                    $KeyAst  = $KvpTuple.Item1
                    $Key     = $KeyAst.Value       # We know it's a BareWord

                    $_ValAst = $KvpTuple.Item2
                    $ExprAst = $_ValAst.PipelineElements.Expression    # We know value will always have this
                    $_Value  = $ExprAst | ConvertFrom-ExpressionAst

                    $Output.Add($Key, $_Value)
                }

                return $Output
            }

            default
            {
                $Exception = [System.NotImplementedException]::new("AST type not supported: $_")
                Write-Error -Exception $Exception -TargetObject $_ -ErrorAction Stop
            }
        }
    }
}
