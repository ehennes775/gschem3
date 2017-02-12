namespace Geda3
{
    /**
     * Functions for working with bus rippers
     */
    namespace BusDirection
    {
        /**
         * The maximum value, inclusive
         */
        public const int MAX = 1;


        /**
         * The minimum value, inclusive
         */
        public const int MIN = -1;


        /**
         * Parse the input file representation of a bus direction
         *
         * @param input the string representation of the bus direction
         * @return the bus direction
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * range of bus directions
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
                    @"Invalid BusDirection: $input"
                    );
            }

            if ((result2 < MIN) || (result2 > MAX))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"BusDirection out of range: $input"
                    );
            }

            return (int) result2;
        }
    }
}
