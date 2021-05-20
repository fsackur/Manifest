function ConvertFrom-ExpressionAst
{
    param
    (
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ExpressionAst]$ExpressionAst
    )

    $Output = [ordered]@{}

    $KvpTuples = $ExpressionAst.KeyValuePairs
    foreach ($KvpTuple in $KvpTuples)
    {
        $KeyAst  = $KvpTuple.Item1
        $Key     = $KeyAst.Value       # We know it's a BareWord

        $ValAst  = $KvpTuple.Item2
        $ExprAst = $ValAst.PipelineElements.Expression    # We know value will always have this

        switch ($ExprAst.GetType())
        {
            ([System.Management.Automation.Language.StringConstantExpressionAst])
            {
                $Output.Add($Key, $ExprAst.Value)
            }

            ([System.Management.Automation.Language.ArrayExpressionAst])
            {
                $ElementAsts = $ExprAst.SubExpression.Statements.PipelineElements.Expression.Elements
                $Output.Add($Key, $ElementAsts.Value)
            }

            ([System.Management.Automation.Language.HashtableAst])
            {
                $Output.Add($Key, (ConvertFrom-ExpressionAst $ExprAst))
            }
        }
    }

    return $Output
}
