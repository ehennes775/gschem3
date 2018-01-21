namespace Geda3
{
    public abstract class SchematicPainter
    {
        /**
         * Draw a box
         *
         * @param x0 The x coordinate of the first corner
         * @param y0 The y coordinate of the first corner
         * @param x1 The x coordinate of the second corner
         * @param y1 The y coordinate of the second corner
         */
        public abstract void draw_box(int x0, int y0, int x1, int y1);


        /**
         * Draw a circle
         *
         * @param center_x The x coordinate of the center
         * @param center_y The y coordinate of the center
         * @param radius The radius of the circle
         */
        public abstract void draw_circle(int center_x, int center_y, int radius);


        /**
         * Draw a line
         *
         * @param x0 The x coordinate of the first point
         * @param y0 The y coordinate of the first point
         * @param x1 The x coordinate of the second point
         * @param y1 The y coordinate of the second point
         */
        public abstract void draw_line(int x0, int y0, int x1, int y1);


        /**
         * Set the cap type to use for line ends
         *
         * @param cap_type The cap type to use for further drawing
         */
        public abstract void set_cap_type(CapType cap_type);


        /**
         * Set the drawing color the index specified
         *
         * @param index The color index in the color scheme
         */
        public abstract void set_color(int index);


        /**
         * Set the dash style
         *
         * @param dash_type The type of dashes to draw
         * @param length The length of the dashes
         * @param space The length of the gaps between the dashes
         */
        public abstract void set_dash(DashType dash_type, int length, int space);


        /**
         * Set the line width
         *
         * @param width The width for drawing lines
         */
        public abstract void set_width(int width);
    }
}
