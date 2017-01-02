namespace Geda3
{
    /**
     * Functions for operating on coordinates
     */
    namespace Color
    {
        /**
         * The color index of the background color
         */
        public const int BACKGROUND = 0;


        /**
         * The default color index for schematic nets
         */
        public const int NET = 4;


        /**
         * Parse the string representation of a color
         *
         * @param input the string representation of the color
         * @return the coordinate
         * @throw ParseError.INVALID_INTEGER not a valid number
         * @throw ParseError.OUT_OF_RANGE input outside 32 bit integer
         */
        public int parse(string input) throws ParseError
        {
            int64 result;

            var success = int64.try_parse(input, out result);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid color index: $input"
                    );
            }

            if ((result < 0) || (result > int.MAX))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"Color index out of range: $input"
                    );
            }

            return (int) result;
        }
    }
}

