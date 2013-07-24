global class Selector
{
    public class Equals extends IntegerSelector
    {
        Integer find;

        public Equals( Integer find )
        {
            this.find = find;
        }

        public Object doMap( Object input )
        {
            return find == (Integer)input;
        }
    }

    global class NotDivisibleBy extends IntegerSelector
    {
        Integer mod;

        public NotDivisibleBy( Integer mod )
        {
            this.mod = mod;
        }

        public Object doMap( Object input )
        {
            return 0 != Math.mod( (Integer)input, mod );
        }
    }

    global abstract class IntegerSelector extends Base
    {
        public Type getInputType()
        {
            return Integer.class;
        }
    }

    global abstract class Base implements Collection.Mapper
    {
        public Type getOutputType()
        {
            return Boolean.class;
        }
    }
}
