global class Mapper
{
    global class DivideBy extends DoubleMapper
    {
        Double divisor;

        global DivideBy( Double divisor )
        {
            this.divisor = divisor;
        }

        global Object doMap( Object input )
        {
            return ((Double)input) / divisor;
        }
    }

    global class SquareInteger extends IntegerMapper
    {
        global Object doMap( Object input )
        {
            Integer value = input == null ? 0 : (Integer)input;

            return value * value;
        }
    }

    global class OddOrEven implements Collection.Mapper
    {
        global Object doMap( Object input )
        {
            return Math.mod( (Integer)input, 2 ) == 0 ? 'even' : 'odd';
        }

        global Type getInputType()
        {
            return Integer.class;
        }

        global Type getOutputType()
        {
            return String.class;
        }
    }

    global class MultiplyByLog extends DoubleMapper
    {
        global Object doMap( Object input )
        {
            return ((Double)input) * Math.log10( (Double)input );
        }
    }

    global abstract class DoubleMapper implements Collection.Mapper
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

    global abstract class IntegerMapper implements Collection.Mapper
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
}
