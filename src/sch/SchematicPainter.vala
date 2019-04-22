namespace Geda3
{
    public abstract class SchematicPainter : PathCommandReceiver
    {
        /**
         * Draw an arc
         *
         * @param center_x The x coordinate of the center
         * @param center_y The y coordinate of the center
         * @param radius The radius of the arc
         * @param start The starting angle in degrees
         * @param sweep The sweep in degrees
         */
        public abstract void draw_arc(
            int center_x,
            int center_y,
            int radius,
            int start,
            int sweep
            );


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
         * Draw a grip
         *
         * @param center_x The x coordinate of the center
         * @param center_y The y coordinate of the center
         */
        public abstract void draw_grip(
            int center_x,
            int center_y,
            double half_width
            );


        public abstract void draw_items(
            int x,
            int y,
            int angle,
            bool mirror,
            Gee.Collection<SchematicItem> items,
            bool reveal,
            bool selected
            );


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
         * Draw a path
         *
         * @param commands The commands that make up the path
         */
        public abstract void draw_path(Gee.List<PathCommand> commands);


        /**
         * Draw a round grip
         *
         * @param center_x The x coordinate of the center
         * @param center_y The y coordinate of the center
         */
        public abstract void draw_round_grip(
            double center_x,
            double center_y,
            double half_width
            );


        /**
         * Draw the box used to select items
         *
         * @param x0 The x coordinate of the first corner in device units
         * @param y0 The y coordinate of the first corner in device units
         * @param x1 The x coordinate of the second corner in device units
         * @param y1 The y coordinate of the second corner in device units
         */
        public abstract void draw_select_box(int x0, int y0, int x1, int y1);


        /**
         * Draw an x to mark an instertion point
         *
         * @param x The x coordinate of the insertion point
         * @param y The y coordinate of the insertion point
         * @param alignment The text alignment
         * @param size The size of the text in points
         * @param text The visible text
         */
        public abstract void draw_text(int x, int y, TextAlignment alignment, int angle, int size, string text);


        /**
         * Draw an x to mark an instertion point
         *
         * @param x The x coordinate of the insertion point
         * @param y The y coordinate of the insertion point
         */
        public abstract void draw_x(int x, int y);


        /**
         * Draw the box used to select items
         *
         * @param x0 The x coordinate of the first corner in device units
         * @param y0 The y coordinate of the first corner in device units
         * @param x1 The x coordinate of the second corner in device units
         * @param y1 The y coordinate of the second corner in device units
         */
        public abstract void draw_zoom_box(int x0, int y0, int x1, int y1);


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
        public abstract void set_color(int index, bool ghost = false);


        /**
         * Set the dash style
         *
         * @param dash_type The type of dashes to draw
         * @param length The length of the dashes
         * @param space The length of the gaps between the dashes
         */
        public abstract void set_dash(DashType dash_type, int length, int space);


        public abstract void set_fill_type(FillType fill_type);

        /**
         * Set the line width
         *
         * @param width The width for drawing lines
         */
        public abstract void set_width(int width);


        public abstract Geda3.Bounds calculate_text_bounds(int x, int y, TextAlignment alignment, int angle, int size, string text);


        /**
         *
         */
        public abstract void close_path();


        /**
         *
         */
        public abstract void line_to_absolute(int x, int y);


        /**
         *
         */
        public abstract void line_to_relative(int x, int y);


        /**
         *
         */
        public abstract void move_to_absolute(int x, int y);


        /**
         *
         */
        public abstract void move_to_relative(int x, int y);
    }
}
