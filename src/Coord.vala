namespace Geda3
{
    /**
     * Functions for operating on coordinates
     */
    namespace Coord
    {
        /**
         * Parse the string representation of a coordinate
         *
         * @param input the string representation of the coordinate
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
                    @"Invalid coordinate: $input"
                    );
            }

            if ((result < int.MIN) || (result > int.MAX))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"Coordinate out of range: $input"
                    );
            }

            return (int) result;
        }


        /**
         * Snap a coordinate to the nearest grid
         *
         * @param coord the coordinate
         * @param grid the grid size
         * @return the snapped coordinate
         */
        public int snap(int coord, int grid)

            requires(grid > 0)

        {
            int sign = (coord >= 0) ? 1 : -1;
            int val = coord.abs();

            int dividend = val / grid;
            int remainder = val % grid;

            int result = dividend * grid;

            if (remainder > (grid / 2))
            {
                result += grid;
            }

            return sign * result;
        }
    }
}

