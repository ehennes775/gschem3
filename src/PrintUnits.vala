namespace Geda3
{
    /**
     * Units of length used for printing
     */
    public enum PrintUnits
    {
        /**
         * Inches
         */
        IN,

        /**
         * Millimeters
         */
        MM,

        /**
         * The number of print units
         */
        COUNT;


        /**
         * The string representation for inches
         */
        public const string IN_STRING = "in";


        /**
         * The string representation for millimeters
         */
        public const string MM_STRING = "mm";


        /**
         * Parse the string representation of print units
         *
         * @param input the string representation of the print units
         * @return the print units
         * @throws
         */
        public static PrintUnits parse(string input) throws ParseError

            ensures(result >= 0)
            ensures(result < COUNT)

        {
            var units = IN;

            if (input.ascii_casecmp(MM_STRING) == 0)
            {
                units = MM;
            }
            else if (input.ascii_casecmp(IN_STRING) != 0)
            {
                throw new ParseError.INVALID_UNITS(
                    @"Invalid units: $input"
                    );
            }

            return units;
        }


        /**
         * Convert units into a string representation
         *
         * \return The string representation of the units
         */
        public string to_string()
        {
            switch (this)
            {
                case IN:
                    return IN_STRING;

                case MM:
                    return MM_STRING;

                default:
                    assert_not_reached();
            }
        }
    }
}
