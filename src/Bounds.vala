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
         * Create a bounds with points
         *
         * @param x0 x coordinate of first point
         * @param y0 y coordinate of first point
         * @param x1 x coordinate of second point
         * @param y1 y coordinate of second point
         */
        public Bounds.with_points(int x0, int y0, int x1, int y1)
        {
            min_x = int.min(x0, x1);
            min_y = int.min(y0, y1);
            max_x = int.max(x0, x1);
            max_y = int.max(y0, y1);
        }


        /**
         * Checks if a point lies inside the bounds
         *
         * @return true if the point lies inside the bounds
         */
        public bool contains(int x, int y)
        {
            return (x >= min_x) && (x <= max_x) &&
                   (y >= min_y) && (y <= max_y);
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


        /**
         * Expand the bounds
         *
         * @param x the amount to expand on the left and right
         * @param y the amount to expand on the top and bottom
         */
        public void expand(int x, int y)

            requires(x >= 0)
            requires(y >= 0)

        {
            if (!empty())
            {
                min_x -= x;
                min_y -= y;
                max_x += x;
                max_y += y;
            }
        }


        /**
         * Calculate the union of two bounds
         *
         * @param other the other bounds to use for calculation
         */
        public void union(Bounds other)
        {
            min_x = int.min(min_x, other.min_x);
            min_y = int.min(min_y, other.min_y);
            max_x = int.max(max_x, other.max_x);
            max_y = int.max(max_y, other.max_y);
        }
    }
}
