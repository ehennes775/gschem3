namespace Geda3
{
    /**
     * The fill type for closed shapes
     */
    public enum FillType
    {
        /**
         * The shape is not filled
         */
        HOLLOW,

        /**
         * The shape is filled with a solid color
         */
        FILL,

        /**
         * The shape is filled with a mesh (cross-hatched)
         *
         * This setting uses both fill angles and pitches.
         */
        MESH,

        /**
         * The shape is hached
         *
         * This setting only uses the first fill angle and pitch.
         */
        HATCH,

        /**
         * The number of fill options
         */
        COUNT;


        /**
         * Parse the input file representation of a FillType
         *
         * @param input the string representation of the fill type
         * @return the fill type
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * range of fill types
         */
        public static FillType parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid FillType: $input"
                    );
            }

            if ((result2 < 0) || (result2 >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"FillType out of range: $input"
                    );
            }

            return (FillType) result2;
        }


        /**
         * Indicates fill type uses first angle, pitch, and width
         */
        public bool uses_first_set()
        {
            return (this == HATCH) || (this == MESH);
        }


        /**
         * Indicates fill type uses second angle, and pitch
         */
        public bool uses_second_set()
        {
            return (this == MESH);
        }
    }
}
