namespace Gschem3
{
    /**
     * Stores colors for drawing schematics
     */
    public class ColorScheme
    {
        /**
         * Create an empty color scheme
         */
        public ColorScheme()
        {
            colors = new Gee.HashMap<int,Gdk.RGBA?>();
        }


        /**
         * Get a color from this color scheme
         *
         * @param index the index
         * @return the color
         */
        public Gdk.RGBA @get(int index)

            requires(colors != null)
            requires(index >= 0)

        {
            Gdk.RGBA? color = null;

            if (colors.has_key(index))
            {
                color = colors[index];
            }

            if (color == null)
            {
                color = Gdk.RGBA()
                {
                    red   = 1.0,
                    green = 1.0,
                    blue  = 1.0,
                    alpha = 0.0
                };
            }

            return (!) color;
        }


        /**
         * Stores the colors for this color scheme
         */
        private Gee.HashMap<int,Gdk.RGBA?> colors;
    }
}
