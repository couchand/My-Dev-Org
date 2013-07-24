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
