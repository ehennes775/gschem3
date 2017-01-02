namespace Geda3
{
    /**
     * Represents the dash type for lines
     */
    public enum DashType
    {
        SOLID,
        DOTTED,
        DASHED,
        CENTER,
        PHANTOM,
        COUNT;


        /**
         * The default dash length
         */
        public const int DEFAULT_LENGTH = 10;


        /**
         * The default dash spacing
         */
        public const int DEFAULT_SPACE = 10;


        /**
         * Parse the input file representation of a dash type
         *
         * @param input the string representation of the dash type
         * @return a valid dash type
         * @throws ParseError.INVALID_INTEGER not a valid number
         * @throws ParseError.OUT_OF_RANGE input outside 32 bit integer
         */
        public static DashType parse(string input) throws ParseError
        {
            int64 result;

            var success = int64.try_parse(input, out result);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid DashType: $input"
                    );
            }

            if ((result < 0) || (result >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"DashType out of range: $input"
                    );
            }

            return (DashType) result;
        }


        /**
         * Parse the dash length value from input file representation
         *
         * @param input the dash length in file representation
         * @return the dash length in internal representation
         * @throws ParseError.INVALID_INTEGER the input parameter does
         * not represent a valid integer
         * @throws ParseError.OUT_OF_RANGE the input parameter is out
         * of range for dash length
         */
        public int parse_length(string input) throws ParseError

            requires(this >= 0)
            requires(this < COUNT)

        {
            int64 result = DEFAULT_LENGTH;

            if (uses_length())
            {
                var success = int64.try_parse(input, out result);

                if (!success)
                {
                    throw new ParseError.INVALID_INTEGER(
                        @"Invalid DashLength: $input"
                        );
                }

                if ((result < 1) || (result >= int.MAX))
                {
                    throw new ParseError.OUT_OF_RANGE(
                        @"DashLength out of range: $input"
                        );
                }
            }

            return (int) result;
        }


        /**
         * Parse the dash space value from input file representation
         *
         * @param input the dash space in file representation
         * @return the dash space in internal representation
         * @throws ParseError.INVALID_INTEGER the input parameter does
         * not represent a valid integer
         * @throws ParseError.OUT_OF_RANGE the input parameter is out
         * of range for dash space
         */
        public int parse_space(string input) throws ParseError

            requires(this >= 0)
            requires(this < COUNT)

        {
            int64 result = DEFAULT_SPACE;

            if (uses_space())
            {
                var success = int64.try_parse(input, out result);

                if (!success)
                {
                    throw new ParseError.INVALID_INTEGER(
                        @"Invalid DashSpace: $input"
                        );
                }

                if ((result < 1) || (result >= int.MAX))
                {
                    throw new ParseError.OUT_OF_RANGE(
                        @"DashSpace out of range: $input"
                        );
                }
            }

            return (int) result;
        }


        /**
         * Indicates this dash type uses the length parameter
         *
         * @return TRUE if this dash type uses the length parameter
         */
        public bool uses_length()

            requires(this >= 0)
            requires(this < COUNT)

        {
            return (this != SOLID) && (this != DOTTED);
        }


        /**
         * Indicates this dash type uses the space parameter
         *
         *  @return TRUE if this dash type uses the space parameter
         */
        public bool uses_space()

            requires(this >= 0)
            requires(this < COUNT)

        {
            return (this != SOLID);
        }
    }
}
