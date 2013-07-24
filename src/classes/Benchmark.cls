global class Benchmark
{
    @TestVisible Map<String, Integer> factorsStart;
    @TestVisible Map<String, Integer> factorsEnd;

    global Benchmark()
    {
        factorsStart = getLimits();
    }

    global void stop()
    {
        factorsEnd = getLimits();
    }

    global Integer getNetUsage( String factor )
    {
        Integer usage = factorsEnd.get( factor ) - factorsStart.get( factor );
        return factor == 'ScriptStatements' ? usage - 2 : usage;
    }

    global static Set<String> getFactors()
    {
        return new Set<String>
        {
            'AggregateQueries',
            'Callouts',
            'ChildRelationshipsDescribes',
            'CpuTime',
            'DMLRows',
            'DMLStatements',
            'EmailInvocations',
            'FieldsDescribes',
            'FieldSetsDescribes',
            'FindSimilarCalls',
            'FutureCalls',
            'HeapSize',
            'InteractionQueries',
            'Queries',
            'PicklistDescribes',
            'QueryLocatorRows',
            'QueryRows',
            'RecordTypesDescribes',
            'ScriptStatements',
            'SoslQueries'
        };
    }

    global static Map<String, Integer> getLimits()
    {
        return new Map<String, Integer>
        {
            'AggregateQueries'              => Limits.getAggregateQueries(),
            'Callouts'                      => Limits.getCallouts(),
            'ChildRelationshipsDescribes'   => Limits.getChildRelationshipsDescribes(),
            'CpuTime'                       => Limits.getCpuTime(),
            'DMLRows'                       => Limits.getDMLRows(),
            'DMLStatements'                 => Limits.getDMLStatements(),
            'EmailInvocations'              => Limits.getEmailInvocations(),
            'FieldsDescribes'               => Limits.getFieldsDescribes(),
            'FieldSetsDescribes'            => Limits.getFieldSetsDescribes(),
            'FindSimilarCalls'              => Limits.getFindSimilarCalls(),
            'FutureCalls'                   => Limits.getFutureCalls(),
            'HeapSize'                      => Limits.getHeapSize(),
            'InteractionQueries'            => Limits.getInteractionQueries(),
            'Queries'                       => Limits.getQueries(),
            'PicklistDescribes'             => Limits.getPicklistDescribes(),
            'QueryLocatorRows'              => Limits.getQueryLocatorRows(),
            'QueryRows'                     => Limits.getQueryRows(),
            'RecordTypesDescribes'          => Limits.getRecordTypesDescribes(),
            'ScriptStatements'              => Limits.getScriptStatements(),
            'SoslQueries'                   => Limits.getSoslQueries()
        };
    }
}
