namespace Geda3
{
    /**
     * Represents the type of cap for lines
     */
    public enum CapType
    {
        NONE,
        SQUARE,
        ROUND,
        COUNT;

        /**
         * Parse the input file representation of a CapType
         *
         * @param input the string representation of the cap type
         * @return the cap type
         * @throws ParseError.INVALID_INTEGER not a valid number
         * @throws ParseError.OUT_OF_RANGE input outside 32 valid cap
         * type range
         */
        public static CapType parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid CapType: $input"
                    );
            }

            if ((result2 < 0) || (result2 >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"CapType out of range: $input"
                    );
            }

            return (CapType) result2;
        }
    }
}
