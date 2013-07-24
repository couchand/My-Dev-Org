global class Reducer
{
    global class SumInteger extends IntegerReducer
    {
        global Object doReduce( Object input, Object current )
        {
            return ( input == null ? 0 : (Integer)input ) +
                   ( current == null ? 0 : (Integer)current );
        }
    }

    global class SumDouble extends DoubleReducer
    {
        global Object doReduce( Object input, Object current )
        {
            if ( current == null )
            {
                return input;
            }
            return ((Double)input) + ((Double)current);
        }
    }

    global class Maximum extends IntegerReducer
    {
        global Object doReduce( Object input, Object current )
        {
            if ( null == current )
            {
                return input;
            }

            return Math.max( (Integer)input, (Integer)current );
        }
    }

    public class Count implements Collection.Reducer
    {
        public Object doReduce( Object input, Object current )
        {
            return ( input == null ? 0 : 1 ) +
                   ( current == null ? 0 : (Integer)current );
        }

        public Type getInputType()
        {
            return Object.class;
        }

        public Type getOutputType()
        {
            return Integer.class;
        }
    }

    global class FirstIndex extends IntegerReducer
    {
        Integer find, index;

        global FirstIndex( Integer find )
        {
            this.find = find;
            this.index = 0;
        }

        global Object doReduce( Object input, Object current )
        {
            if ( current == null && find == input )
            {
                current = index;
            }

            index++;

            return current;
        }
    }

    global abstract class IntegerReducer implements Collection.Reducer
    {
        global Type getInputType()
        {
            return Integer.class;
        }

        global Type getOutputType()
        {
            return Integer.class;
        }
    }

    global abstract class DoubleReducer implements Collection.Reducer
    {
        global Type getInputType()
        {
            return Double.class;
        }

        global Type getOutputType()
        {
            return Double.class;
        }
    }
}
