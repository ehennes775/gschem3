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
         * The default color index for schematic busses
         */
        public const int BUS = 10;


        /**
         * The default color index for graphic objects
         */
        public const int GRAPHIC = 3;


        /**
         * The default color index for junctions
         */
        public const int JUNCTION = 21;


        /**
         * The default color index for major grid lines
         */
        public const int MAJOR_GRID = 22;


        /**
         * The default color index minor grid lines
         */
        public const int MINOR_GRID = 23;


        /**
         * The default color index for schematic nets
         */
        public const int NET = 4;


        /**
         * The default color index for schematic pins
         */
        public const int PIN = 1;


        /**
         * The default color index for graphic objects
         */
        public const int TEXT = 9;


        /**
         * Parse the string representation of a color
         *
         * @param input the string representation of the color
         * @return the coordinate
         * @throws ParseError.INVALID_INTEGER not a valid number
         * @throws ParseError.OUT_OF_RANGE input outside 32 bit integer
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

