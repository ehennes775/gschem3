namespace Geda3
{
    /**
     * Functions for operating on coordinates
     */
    namespace Color
    {
        /**
         * The default color index for attributes
         */
        public const int ATTRIBUTE = 5;

        /**
         * The color index of the background color
         */
        public const int BACKGROUND = 0;


        /**
         * The color index to use for a selection box
         */
        public const int BOUNDING_BOX = 12;


        /**
         * The default color index for schematic busses
         */
        public const int BUS = 10;


        /**
         * The default color index for detached attributes
         */
        public const int DETACHED_ATTRIBUTE = 8;


        /**
         * The default color index for graphic objects
         */
        public const int GRAPHIC = 3;


        /**
         * The default color index for junctions
         */
        public const int JUNCTION = 21;


        /**
         * The default color index for logic bubbles
         */
        public const int LOGIC_BUBBLE = 6;


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
         * The color index for selected objects
         */
        public const int SELECT = 11;


        /**
         * The default color index for graphic objects
         */
        public const int TEXT = 9;


        /**
         * The color index for selecting an area to zoom
         */
        public const int ZOOM_BOX = 13;


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

