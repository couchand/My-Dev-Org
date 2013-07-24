global virtual class Collection
{
    global interface Mapper
    {
        Object doMap( Object input );
        Type getInputType();
        Type getOutputType();
    }

    global interface Reducer
    {
        Object doReduce( Object input, Object current );
        Type getInputType();
        Type getOutputType();
    }


    global Collection()
    {
        this.members = new List<Object>();
    }

    global Collection( List<Object> members )
    {
        this.members = members;
    }

    global Boolean isEmpty()
    {
        return members.isEmpty();
    }

    global Integer size()
    {
        return members.size();
    }

    global virtual Object shift()
    {
        return members.remove( 0 );
    }

    global virtual Collection doSelect( Mapper selector )
    {
        List<Object> newMembers = new List<Object>();

        for ( Object member : members )
        {
            if ( (Boolean)selector.doMap( member ) )
            {
                newMembers.add( member );
            }
        }

        return new Collection( newMembers );
    }

    global virtual Collection removeIf( Mapper selector )
    {
        List<Object> ejected = new List<Object>();
        List<Object> saved = new List<Object>();

        for ( Object member : members )
        {
            if ( (Boolean)selector.doMap( member ) )
            {
                ejected.add( member );
            }
            else
            {
                saved.add( member );
            }
        }

        members = saved;
        return new Collection( ejected );
    }

    global virtual Collection doMap( Mapper mapper )
    {
        List<Object> accumulator = new List<Object>();

        for ( Object member : members )
        {
            accumulator.add( mapper.doMap( member ) );
        }

        return new Collection( accumulator );
    }

    global virtual Object doReduce( Reducer reducer )
    {
        return doReduce( reducer, null );
    }

    global virtual Object doReduce( Reducer reducer, Object initial )
    {
        for ( Object member : members )
        {
            initial = reducer.doReduce( member, initial );
        }

        return initial;
    }

    global static Collection doUnfold( Mapper mapper, Object initial )
    {
        List<Object> objects = new List<Object>();

        Object next = mapper.doMap( initial );

        while ( null != next )
        {
            objects.add( next );
            next = mapper.doMap( initial  );
        }

        return new Collection( objects );
    }

    global virtual GroupedCollection doGroup( Mapper mapper )
    {
        Map<Object, List<Object>> reduced = new Map<Object, List<Object>>();

        for ( Object input : members )
        {
            Object key = mapper.doMap( input );

            if ( reduced.containsKey( key ) )
            {
                reduced.get( key ).add( input );
            }
            else
            {
                reduced.put( key, new List<Object>{ input } );
            }
        }

        Map<Object, Collection> collections = new Map<Object, Collection>();

        for ( Object key : reduced.keySet() )
        {
            collections.put( key, new Collection( reduced.get( key ) ) );
        }

        return new GroupedCollection( collections );
    }

    @TestVisible private List<Object> members;

    global virtual class GroupedCollection extends Collection
    {
        global GroupedCollection( Map<Object, Collection> groups )
        {
            this.groups = groups;
        }

        global virtual override Collection doMap( Mapper mapper )
        {
            Map<Object, Collection> returnMap = new Map<Object, Collection>();

            for ( Object key : groups.keySet() )
            {
                returnMap.put( key, groups.get( key ).doMap( mapper ) );
            }

            return new GroupedCollection( returnMap );
        }

        global virtual override Object doReduce( Reducer reducer, Object initial )
        {
            Map<Object, Object> reduced = new Map<Object, Object>();

            for ( Object key : groups.keySet() )
            {
                reduced.put( key, groups.get( key ).doReduce( reducer, initial ) );
            }

            return new Collection( reduced.values() ).doReduce( reducer, initial );
        }

        global virtual override GroupedCollection doGroup( Mapper mapper )
        {
            Map<Object, GroupedCollection> nested = new Map<Object, GroupedCollection>();

            for ( Object key : groups.keySet() )
            {
                nested.put( key, groups.get( key ).doGroup( mapper ) );
            }

            return new GroupedCollection( nested );
        }

        @TestVisible private Map<Object, Collection> groups;
    }
}
