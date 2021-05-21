function ConvertFrom-ExpressionAst
{
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [System.Management.Automation.Language.ExpressionAst]$ExpressionAst,

        [switch]$AsExtent
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
                if ($AsExtent)
                {
                    return $ExpressionAst.Extent
                }
                else
                {
                    return $ExpressionAst.Value
                }
            }

            ([System.Management.Automation.Language.ArrayLiteralAst])
            {
                return ,@($ExpressionAst.Elements | ConvertFrom-ExpressionAst -AsExtent:$AsExtent)
            }

            ([System.Management.Automation.Language.ArrayExpressionAst])
            {
                $SubExprAst = $ExpressionAst.SubExpression.Statements.PipelineElements.Expression
                return ,@($SubExprAst | ConvertFrom-ExpressionAst -AsExtent:$AsExtent)
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
                    $_Value  = $ExprAst | ConvertFrom-ExpressionAst -AsExtent:$AsExtent

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
