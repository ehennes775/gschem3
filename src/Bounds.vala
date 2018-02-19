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
         * Create a bounds with points
         *
         * @param x0 x coordinate of first point
         * @param y0 y coordinate of first point
         * @param x1 x coordinate of second point
         * @param y1 y coordinate of second point
         */
        public Bounds.with_fpoints(double x0, double y0, double x1, double y1)
        {
            min_x = (int) Math.floor(double.min(x0, x1));
            min_y = (int) Math.floor(double.min(y0, y1));
            max_x = (int) Math.ceil(double.max(x0, x1));
            max_y = (int) Math.ceil(double.max(y0, y1));
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
         * Calculate the height of the bounds
         *
         * @return The height of the bounds
         */
        public int get_height()
        {
            int height = 0;

            if (!empty())
            {
                height = max_y - min_y + 1;
            }

            return height;
        }


        /**
         * Calculate the width of the bounds
         *
         * @return The width of the bounds
         */
        public int get_width()
        {
            int width = 0;

            if (!empty())
            {
                width = max_x - min_x + 1;
            }

            return width;
        }


        /**
         * Create a string for debugging
         *
         * @return
         */
        public string to_string()
        {
            return @"Bounds min_x=$(min_x) min_y=$(min_y) max_x=$(max_x) max_y=$(max_y)";
        }


        /**
         * Rotate the bounds around the origin
         *
         * @param angle The angle to rotate the bounds in degrees
         */
        public void rotate(int angle)
        {
            double x[] =
            {
                min_x,
                max_x,
                min_x,
                max_x
            };

            double y[] =
            {
                min_y,
                min_y,
                max_y,
                max_y
            };

            var matrix = Cairo.Matrix.identity();
            matrix.rotate(Angle.to_radians(angle));

            for (var index = 0; index < 4; index++)
            {
                matrix.transform_point(ref x[index], ref y[index]);
            }

            var fmin_x = x[0];
            var fmin_y = y[0];
            var fmax_x = x[0];
            var fmax_y = y[0];

            for (var index = 1; index < 4; index++)
            {
                fmin_x = double.min(fmin_x, x[index]);
                fmin_y = double.min(fmin_y, y[index]);
                fmax_x = double.max(fmax_x, x[index]);
                fmax_y = double.max(fmax_y, y[index]);
            }

            min_x = (int) Math.floor(fmin_x);
            min_y = (int) Math.floor(fmin_y);
            max_x = (int) Math.ceil(fmax_x);
            max_y = (int) Math.ceil(fmax_y);
        }


        /**
         * Translate the bounds
         *
         * @param dx The displacement on the x axis
         * @param dy The displacement on the y axis
         */
        public void translate(int dx, int dy)
        {
            min_x += dx;
            min_y += dy;
            max_x += dx;
            max_y += dy;
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
