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
         * Extract the text alignment from a value
         *
         * @param input The value to extract a text alignment from
         */
        public static TextAlignment from_value(Value input)
        {
            return (TextAlignment) input.get_enum();
        }


        /**
         * Parse the input file representation of a TextAlignment
         *
         * @param input the string representation of the text alignment
         * @return the text alignment
         * @throws ParseError.INVALID_INTEGER the input is not a valid
         * number
         * @throws ParseError.OUT_OF_RANGE the input is outside the
         * valid range of text alignments
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


        /**
         * Provides a value for the horizontal alignment
         *
         * ||''Value''||''Description''||
         * ||0.0||left||
         * ||0.5||center||
         * ||1.0||right||
         * 
         * @return A value representing the horizontal alignment
         */
        public double alignment_x()

            ensures(result >= 0.0)
            ensures(result <= 1.0)

        {
            double result2;
            
            switch (this)
            {
                case LOWER_RIGHT:
                case MIDDLE_RIGHT:
                case UPPER_RIGHT:
                    result2 = 1.0;
                    break;

                case LOWER_MIDDLE:
                case MIDDLE_MIDDLE:
                case UPPER_MIDDLE:
                    result2 = 0.5;
                    break;
                    
                default:
                    result2 = 0.0;
                    break;
            }

            return result2;
        }


        /**
         * Provides a value for the vertical alignment
         *
         * ||''Value''||''Description''||
         * ||0.0||top||
         * ||0.5||center||
         * ||1.0||bottom||
         *
         * @return A value representing the vertical alignment
         */
        public double alignment_y()

            ensures(result >= 0.0)
            ensures(result <= 1.0)

        {
            double result2;
            
            switch (this)
            {
                case LOWER_LEFT:
                case LOWER_MIDDLE:
                case LOWER_RIGHT:
                    result2 = 1.0;
                    break;

                case MIDDLE_LEFT:
                case MIDDLE_MIDDLE:
                case MIDDLE_RIGHT:
                    result2 = 0.5;
                    break;
                    
                default:
                    result2 = 0.0;
                    break;
            }

            return result2;
        }


        /**
         * Mirror the text alignment on the x axis
         *
         * @return The text alignment mirrored on the x axis
         */
        public TextAlignment mirror_x()

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            switch (this)
            {
                case LOWER_LEFT:
                    return LOWER_RIGHT;

                case MIDDLE_LEFT:
                    return MIDDLE_RIGHT;

                case UPPER_LEFT:
                    return UPPER_RIGHT;

                case LOWER_RIGHT:
                    return LOWER_LEFT;

                case MIDDLE_RIGHT:
                    return MIDDLE_LEFT;

                case UPPER_RIGHT:
                    return UPPER_LEFT;

                default:
                    return this;
            }
        }


        /**
         * Mirror the text alignment on the x axis
         *
         * @return The text alignment mirrored on the x axis
         */
        public TextAlignment mirror_y()

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            switch (this)
            {
                case LOWER_LEFT:
                    return UPPER_LEFT;

                case UPPER_LEFT:
                    return LOWER_LEFT;

                case LOWER_MIDDLE:
                    return UPPER_MIDDLE;

                case UPPER_MIDDLE:
                    return LOWER_MIDDLE;

                case LOWER_RIGHT:
                    return UPPER_RIGHT;

                case UPPER_RIGHT:
                    return LOWER_RIGHT;

                default:
                    return this;
            }
        }
    }
}
