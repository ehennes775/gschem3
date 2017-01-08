namespace Geda3
{
    /**
     * Stores a rectangular region
     */
    public struct Bounds
    {
        /**
         * The smallest x coordinate, inclusive
         */
        int min_x;


        /**
         * The smallest y coordinate, inclusive
         */
        int min_y;


        /**
         * The largest x coordinate, inclusive
         */
        int max_x;


        /**
         * The largest y coordinate, inclusive
         */
        int max_y;


        /**
         * Create an empty bounds
         */
        public Bounds()
        {
            min_x = int.MAX;
            min_y = int.MAX;
            max_x = int.MIN;
            max_y = int.MIN;
        }


        /**
         * Checks if the bounds is empty
         *
         * @return true if the bounds is empty
         */
        public bool empty()
        {
            return ((min_x > max_x) || (min_y > max_y));
        }
    }
}
