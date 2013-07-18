public class Collection
{
    public interface Mapper
    {
        Object doMap( Object input );
    }

    public interface Reducer
    {
        Object doReduce( Object input, Object current );
    }

    public Collection( List<Object> members )
    {
        this.members = members;
    }

    public Collection doMap( Mapper mapper )
    {
        List<Object> accumulator = new List<Object>();

        for ( Object member : members )
        {
            accumulator.add( mapper.doMap( member ) );
        }

        return new Collection( accumulator );
    }

    public Object doReduce( Reducer reducer )
    {
        return doReduce( reducer, null );
    }

    public Object doReduce( Reducer reducer, Object initial )
    {
        for ( Object member : members )
        {
            initial = reducer.doReduce( member, initial );
        }

        return initial;
    }

    public Map<Object, Collection> doGroup( Mapper mapper )
    {
        return (Map<Object, Collection>)doReduce( new GroupingReducer( mapper ), new Map<Object, Collection>() );
    }

    public class GroupingReducer implements Reducer
    {
        Mapper mapper;

        public GroupingReducer( Mapper mapper )
        {
            this.mapper = mapper;
        }

        public Object doReduce( Object input, Object current )
        {
            Map<Object, Collection> theMap = (Map<Object, Collection>)current;

            Object key = mapper.doMap( input );

            if ( theMap.containsKey( key ) )
            {
                theMap.get( key ).add( input );
            }
            else
            {
                theMap.put( key, new Collection( new List<Object>{ input } ) );
            }

            return theMap;
        }
    }

    public void add( Object newObject )
    {
        members.add( newObject );
    }

    @TestVisible private List<Object> members;
}
