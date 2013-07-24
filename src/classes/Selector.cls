global class Selector
{
    global class Equals extends IntegerSelector
    {
        Integer find;

        global Equals( Integer find )
        {
            this.find = find;
        }

        global Object doMap( Object input )
        {
            return find == (Integer)input;
        }
    }

    global class NotDivisibleBy extends IntegerSelector
    {
        Integer mod;

        global NotDivisibleBy( Integer mod )
        {
            this.mod = mod;
        }

        global Object doMap( Object input )
        {
            return 0 != Math.mod( (Integer)input, mod );
        }
    }

    global abstract class IntegerSelector extends Base
    {
        global Type getInputType()
        {
            return Integer.class;
        }
    }

    global abstract class Base implements Collection.Mapper
    {
        global Type getOutputType()
        {
            return Boolean.class;
        }
    }
}
