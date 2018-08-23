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
         * @throws ParseError.OUT_OF_RANGE input outside valid rang of
         * dash types
         */
        public static DashType parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid DashType: $input"
                    );
            }

            if ((result2 < 0) || (result2 >= COUNT))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"DashType out of range: $input"
                    );
            }

            return (DashType) result2;
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
            int64 result2 = DEFAULT_LENGTH;

            if (uses_length())
            {
                var success = int64.try_parse(input, out result2);

                if (!success)
                {
                    throw new ParseError.INVALID_INTEGER(
                        @"Invalid DashLength: $input"
                        );
                }

                if ((result2 < 1) || (result2 >= int.MAX))
                {
                    throw new ParseError.OUT_OF_RANGE(
                        @"DashLength out of range: $input"
                        );
                }
            }

            return (int) result2;
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
            int64 result2 = DEFAULT_SPACE;

            if (uses_space())
            {
                var success = int64.try_parse(input, out result2);

                if (!success)
                {
                    throw new ParseError.INVALID_INTEGER(
                        @"Invalid DashSpace: $input"
                        );
                }

                if ((result2 < 1) || (result2 >= int.MAX))
                {
                    throw new ParseError.OUT_OF_RANGE(
                        @"DashSpace out of range: $input"
                        );
                }
            }

            return (int) result2;
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
         * @return TRUE if this dash type uses the space parameter
         */
        public bool uses_space()

            requires(this >= 0)
            requires(this < COUNT)

        {
            return (this != SOLID);
        }
    }
}
