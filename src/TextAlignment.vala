namespace Geda3
{
    /**
     * The alignment of text relative to the insertion point
     */
    public enum TextAlignment
    {
        /**
         * Insertion point at lower left
         */
        LOWER_LEFT,

        /**
         * Insertion point at center left
         */
        MIDDLE_LEFT,

        /**
         * Insertion point at upper left
         */
        UPPER_LEFT,

        /**
         * Insertion point at lower center
         */
        LOWER_MIDDLE,

        /**
         * Insertion point in the center
         */
        MIDDLE_MIDDLE,

        /**
         * Insertion point at upper center
         */
        UPPER_MIDDLE,

        /**
         * Insertion point at lower right
         */
        LOWER_RIGHT,

        /**
         * Insertion point at center right
         */
        MIDDLE_RIGHT,

        /**
         * Insertion point at upper right
         */
        UPPER_RIGHT,

        /**
         * The number of text alignments
         */
        COUNT;


        /**
         * Parse the input file representation of a TextAlignment
         *
         * @param input the string representation of the text alignment
         * @return the text alignment
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * range of text alignments
         */
        public static TextAlignment parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid TextAlignment: $input"
                    );
            }

            if ((result2 < 0) || (result2 >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"TextAlignment out of range: $input"
                    );
            }

            return (TextAlignment) result2;
        }
    }
}
