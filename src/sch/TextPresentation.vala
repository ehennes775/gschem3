namespace Geda3
{
    /**
     * Selects the presentation of text attributes
     */
    public enum TextPresentation
    {
        /**
         * Shows both the attribute name and value
         */
        BOTH,

        /**
         * Shows the attribute value
         */
        VALUE,

        /**
         * Shows the attribute name
         */
        NAME,

        /**
         * The number of text presentations
         */
        COUNT;


        /**
         * Parse the input file representation of a TextPresentation
         *
         * @param input the string representation of the text
         * presentation
         * @return the text presentation
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * valid range of text presentations
         */
        public static TextPresentation parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid TextPresentation: $input"
                    );
            }

            if ((result2 < 0) || (result2 >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"TextPresentation out of range: $input"
                    );
            }

            return (TextPresentation) result2;
        }
    }
}
