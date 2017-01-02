namespace Geda3
{
    public abstract class SchematicPainter
    {
        /**
         * Draw a line
         *
         * @param x0
         * @param y0
         * @param x1
         * @param y1
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
         * Set the drawing color the index specified
         *
         * @param index The color index in the color scheme
         */
        public abstract void set_dash(DashType dash_type, int length, int space);
    }
}
