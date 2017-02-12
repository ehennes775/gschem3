namespace Geda3
{
    /**
     * Visibility options for schematic items
     */
    public enum Visibility
    {
        /**
         * The object is invisible
         */
        INVISIBLE,

        /**
         * The object is visible
         */
        VISIBLE,

        /**
         * The number of visibility options
         */
        COUNT;


        /**
         * Parse the input file representation of a visibility option
         *
         * @param input the string representation of the visibility
         * option
         * @return the visibility
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * range of visibility options
         */
        public static Visibility parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid Visibility: $input"
                    );
            }

            if ((result2 < 0) || (result2 >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"Visibility out of range: $input"
                    );
            }

            return (Visibility) result2;
        }
    }
}
