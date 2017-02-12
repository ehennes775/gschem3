namespace Geda3
{
    /**
     * Functions for working with text size
     */
    namespace TextSize
    {
        /**
         * The maximum text size, inclusive
         */
        public const int MAX = int.MAX;


        /**
         * The minimum text size, inclusive
         */
        public const int MIN = 2;


        /**
         * Parse the input file representation of text size
         *
         * @param input the string representation of the text size
         * @return the text size
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * range of text sizes
         */
        public static int parse(string input) throws ParseError

            ensures(result >= MIN)
            ensures(result <= MAX)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid TextSize: $input"
                    );
            }

            if ((result2 < MIN) || (result2 > MAX))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"TextSize out of range: $input"
                    );
            }

            return (int) result2;
        }
    }
}
