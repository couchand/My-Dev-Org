global class Mapper
{
    global class DivideBy extends DoubleMapper
    {
        Double divisor;

        public DivideBy( Double divisor )
        {
            this.divisor = divisor;
        }

        public Object doMap( Object input )
        {
            return ((Double)input) / divisor;
        }
    }

    public class SquareInteger extends IntegerMapper
    {
        public Object doMap( Object input )
        {
            Integer value = input == null ? 0 : (Integer)input;

            return value * value;
        }
    }

    public class OddOrEven implements Collection.Mapper
    {
        public Object doMap( Object input )
        {
            return Math.mod( (Integer)input, 2 ) == 0 ? 'even' : 'odd';
        }

        public Type getInputType()
        {
            return Integer.class;
        }

        public Type getOutputType()
        {
            return String.class;
        }
    }

    global class MultiplyByLog extends DoubleMapper
    {
        public Object doMap( Object input )
        {
            return ((Double)input) * Math.log10( (Double)input );
        }
    }

    global abstract class DoubleMapper implements Collection.Mapper
    {
        public Type getInputType()
        {
            return Double.class;
        }

        public Type getOutputType()
        {
            return Double.class;
        }
    }

    public abstract class IntegerMapper implements Collection.Mapper
    {
        public Type getInputType()
        {
            return Integer.class;
        }

        public Type getOutputType()
        {
            return Integer.class;
        }
    }
}
