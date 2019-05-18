namespace Geda3
{
    /**
     * Functions for operating on coordinates
     */
    namespace Coord
    {
        /**
         * Calculate the distance between two points
         *
         * @param x0 The x coordinate of the first point
         * @param y0 The y coordinate of the first point
         * @param x1 The x coordinate of the second point
         * @param y1 The y coordinate of the second point
         * @return the distance between the two points
         */
        public double distance(int x0, int y0, int x1, int y1)
        {
            return Math.hypot(x1 - x0, y1 - y0);
        }


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
            int64 result2;

            var success = int64.try_parse(input, out result2);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid coordinate: $input"
                    );
            }

            if ((result2 < int.MIN) || (result2 > int.MAX))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"Coordinate out of range: $input"
                    );
            }

            return (int) result2;
        }


        /**
         * Rotate a point
         *
         * @param cx The center of rotation x coordinate
         * @param cy The center of rotation y coordinate
         * @param angle The angle of rotation
         * @param x The rotated x coordinate
         * @param y The rotated y coordinate
         */
        public void rotate(int cx, int cy, int angle, ref int x, ref int y)
        {
            var radians = Angle.to_radians(angle);

            var cos_theta = Math.cos(radians);
            var sin_theta = Math.sin(radians);

            var temp_x = x - cx;
            var temp_y = y - cy;

            var temp2_x = (int) Math.round(temp_x * cos_theta - temp_y * sin_theta);
            var temp2_y = (int) Math.round(temp_x * sin_theta + temp_y * cos_theta);

            x = temp2_x + cx;
            y = temp2_y + cy;
        }


        /**
         * Calculate the shortest distance between a point and a line
         *
         * @param x0 The x coordinate of the first endpoint on the line
         * @param y0 The y coordinate of the first endpoint on the line
         * @param x1 The x coordinate of the second endpoint on the line
         * @param y1 The y coordinate of the second endpoint on the line
         * @param x The x coordinate of the point
         * @param y The y coordinate of the point
         * @return The shortest distance from the point to the line
         */
        public double shortest_distance_line(
            int x0,
            int y0,
            int x1,
            int y1,
            int x,
            int y
            )
        {
            double dx;
            double dy;

            var lx0 = (double)x0;
            var ly0 = (double)y0;
            var ldx = (double)(x1 - lx0);
            var ldy = (double)(y1 - ly0);

            if (ldx == 0 && ldy == 0)
            {
                dx = x - lx0;
                dy = y - ly0;
            }
            else
            {
                var dx0 = ldx * (x - lx0);
                var dy0 = ldy * (y - ly0);

                var t = (dx0 + dy0) / (ldx * ldx + ldy * ldy);

                t = t.clamp(0.0, 1.0);

                var cx = t * ldx + lx0;
                var cy = t * ldy + ly0;

                dx = x - cx;
                dy = y - cy;
            }

            return Math.hypot(dx, dy);
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

            int result2 = dividend * grid;

            if (remainder > (grid / 2))
            {
                result2 += grid;
            }

            return sign * result2;
        }


        /**
         * Snap a line to an orthographic angle
         *
         * @param x0 The x coordinate of the first point
         * @param y0 The y coordinate of the first point
         * @param x1 The x coordinate of the second point
         * @param y1 The y coordinate of the second point
         */
        public void snap_ortho(int x0, int y0, ref int x1, ref int y1)
        {
            var dx = (x1 - x0).abs();
            var dy = (y1 - y0).abs();

            if (dx < dy)
            {
                x1 = x0;
            }
            else
            {
                y1 = y0;
            }
        }
    }
}
