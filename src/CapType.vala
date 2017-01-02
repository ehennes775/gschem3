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
         * @param input the string representation of the color
         * @return the coordinate
         * @throws ParseError.INVALID_INTEGER not a valid number
         * @throws ParseError.OUT_OF_RANGE input outside 32 bit integer
         */
        public static CapType parse(string input) throws ParseError
        {
            int64 result;

            var success = int64.try_parse(input, out result);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid CapType: $input"
                    );
            }

            if ((result < 0) || (result >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"CapType out of range: $input"
                    );
            }

            return (CapType) result;
        }
    }
}
