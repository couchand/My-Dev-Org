public class Collection
{
    public interface Mapper
    {
        Object doMap( Object input );
        Type getInputType();
        Type getOutputType();
    }

    public interface Reducer
    {
        Object doReduce( Object input, Object current );
        Type getInputType();
        Type getOutputType();
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

        return collections;
    }

    public void add( Object newObject )
    {
        members.add( newObject );
    }

    @TestVisible private List<Object> members;
}
