global class Unfolder
{
    public class ValueCount extends Mapper.IntegerMapper
    {
        public Object doMap( Object input )
        {
            Collection values = (Collection)input;

            if ( values.isEmpty() )
            {
                return null;
            }

            Integer first = (Integer)values.shift();
            Collection.Mapper areTheFirst = new Selector.Equals( first );

            return 1 + values.removeIf( areTheFirst ).size();
        }
    }

    public class CountFrom extends Mapper.IntegerMapper
    {
        Integer count;

        public CountFrom( Integer min )
        {
            count = min;
        }

        public Object doMap( Object input )
        {
            if ( count > (Integer)input )
            {
                return null;
            }
            return count++;
        }
    }
}
