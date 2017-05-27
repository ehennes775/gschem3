namespace Geda3
{
    /**
     * A dimension for printing measurments
     */
    public struct PrintDimension
    {
        /**
         * The number without the units
         */
        public double number
        {
            get
            {
                return b_number;
            }
        }


        /**
         * The units for this dimension
         */
        public PrintUnits units
        {
            get
            {
                return b_units;
            }
        }

        
        /**
         * Create a dimension
         *
         * \param number The quantity
         * \param units The units of measure
         */
        public PrintDimension(double number, PrintUnits units)
        {
            b_number = number;
            b_units = units;
        }


        /**
         * Parse a string representatin of a print dimension
         *
         * \param input The string representation of the dimension
         * \return The dimension
         * \throws ParseError.INVALID_UNITS The units are invalid
         */
        public static PrintDimension parse(string input) throws ParseError
        {
            if (s_regex == null)
            {
                try
                {
                    s_regex = new Regex(
                        "^\\s*(\\d+(\\.\\d+)?)\\s*(\\w+)\\s*$"
                        );
                }
                catch (Error error)
                {
                    assert_not_reached();
                }
            }

            MatchInfo match_info;

            var success = s_regex.match(
                input,
                0,
                out match_info
                );

            if (!success || match_info.get_match_count() != 4)
            {
                throw new ParseError.INVALID_UNITS("Invalid dimension");
            }

            var number = match_info.fetch(1);
            var units = match_info.fetch(3);

            // if the string is null, the regex is incorrect
            assert(number != null);

            return new PrintDimension(
                number.to_double(),
                PrintUnits.parse(units)
                );
        }


        /**
         * Get this print dimension in inches
         *
         * \return This print dimension in inches
         */
        public double to_inches()
        {
            switch (b_units)
            {
                case PrintUnits.IN:
                    return b_number;

                case PrintUnits.MM:
                    return b_number / MM_PER_IN;

                default:
                    assert_not_reached();
            }
        }


        /**
         * Get this print dimension in millimeters
         *
         * \return This print dimension in millimeters
         */
        public double to_millimeters()
        {
            switch (b_units)
            {
                case PrintUnits.IN:
                    return MM_PER_IN * b_number;

                case PrintUnits.MM:
                    return b_number;

                default:
                    assert_not_reached();
            }
        }


        /**
         * Get this print dimension in points
         *
         * \return This print dimension in points
         */
        public double to_points()
        {
            return POINTS_PER_IN * to_inches();
        }


        /**
         * Return the string representaion of the print dimension
         *
         * This string is intended to be used in both files and within
         * the user interface.
         * 
         * \return The string representation of the print dimension
         */
        public string to_string()
        {
            var number = "%.2f".printf(b_number);

            return @"$number $(b_units.to_string())";
        }


        /**
         * Points per inch used for conversions
         */
        private const double POINTS_PER_IN = 72;


        /**
         * Millimeters per inch used for conversions
         */
        private const double MM_PER_IN = 25.4;


        /**
         * Regex used for parsing print dimensions
         */
        private static Regex? s_regex = null;


        /**
         * Backing store for the number
         */
        double b_number;


        /**
         * Backing store for the units
         */
        PrintUnits b_units;
    }
}
