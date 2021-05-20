function Parse-HashtableAst
{
    param
    (
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.HashtableAst]$HashtableAst
    )

    $Output = [ordered]@{}

    $KvpTuples = $HashtableAst.KeyValuePairs
    foreach ($KvpTuple in $KvpTuples)
    {
        $KeyAst  = $KvpTuple.Item1
        $Key     = $KeyAst.Value       # We know it's a BareWord

        $ValAst  = $KvpTuple.Item2
        $ExprAst = $ValAst.PipelineElements[0].Expression    # We know value will always have this

        switch ($ExprAst.GetType())
        {
            ([System.Management.Automation.Language.StringConstantExpressionAst])
            {
                $Output.Add($Key, $ExprAst.Value)
            }

            ([System.Management.Automation.Language.ArrayExpressionAst])
            {
                $ElementAsts = $ExprAst.SubExpression.Statements[0].PipelineElements[0].Expression.Elements
                $Output.Add($Key, $ElementAsts.Value)
            }

            ([System.Management.Automation.Language.HashtableAst])
            {
                $Output.Add($Key, (Import-HashtableAst $ExprAst))
            }
        }
    }

    return $Output
}
