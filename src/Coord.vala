namespace Geda3
{
    /**
     * Functions for operating on coordinates
     */
    namespace Coord
    {
        /**
         * Snap a coordinate to the nearest grid
         *
         * @param coord the coordinate
         * @param grid the grid size
         * @return the snapped coordinate
         */
        int snap(int coord, int grid)

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

