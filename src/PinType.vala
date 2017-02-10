namespace Geda3
{
    /**
     * Represents the pin type
     */
    public enum PinType
    {
        NORMAL,
        BUS,
        COUNT;


       /**
         * Parse the input file representation of a PinType
         *
         * @param input the string representation of the pin type
         * @return the pin type
         * @throws ParseError.INVALID_INTEGER not a valid number
         * @throws ParseError.OUT_OF_RANGE input outside 32 bit integer
         */
        public static PinType parse(string input) throws ParseError
        {
            int64 result;

            var success = int64.try_parse(input, out result);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid PinType: $input"
                    );
            }

            if ((result < 0) || (result >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"PinType out of range: $input"
                    );
            }

            return (PinType) result;
        }
    }
}
