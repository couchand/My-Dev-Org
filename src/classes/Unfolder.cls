global class Unfolder
{
    global class ValueCount extends Mapper.IntegerMapper
    {
        global Object doMap( Object input )
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

    global class CountFrom extends Mapper.IntegerMapper
    {
        Integer count;

        global CountFrom( Integer min )
        {
            count = min;
        }

        global Object doMap( Object input )
        {
            if ( count > (Integer)input )
            {
                return null;
            }
            return count++;
        }
    }
}
