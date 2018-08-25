namespace Geda3
{
    /**
     * Represents the type of pin
     */
    public enum PinType
    {
        /**
         * The pin uses the style of a net
         */
        NET,

        /**
         * The pin uses the style of a bus
         */
        BUS,

        /**
         * The number of pin types
         */
        COUNT;


        /**
         * Parse the input file representation of a PinType
         *
         * @param input the string representation of the pin type
         * @return the pin type
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * range of PinType
         */
        public static PinType parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid PinType: $input"
                    );
            }

            if ((result2 < 0) || (result2 >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"PinType out of range: $input"
                    );
            }

            return (PinType) result2;
        }
    }
}
