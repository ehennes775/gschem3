namespace Geda3
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
         * Create a dark color scheme
         */
        public ColorScheme.Dark()
        {
            colors = new Gee.HashMap<int,Gdk.RGBA?>();

            colors.@set(
                Color.BOUNDING_BOX,
                Gdk.RGBA()
                {
                    red = 1.0, green = 0.65, blue = 0.0, alpha = 1.0
                });

            colors.@set(
                Color.ZOOM_BOX,
                Gdk.RGBA()
                {
                    red = 0.0, green = 1.0, blue = 1.0, alpha = 1.0
                });

            colors.@set(
                Color.SELECT,
                Gdk.RGBA()
                {
                    red = 1.0, green = 0.65, blue = 0.0, alpha = 1.0
                });

            colors.@set(
                Color.NET,
                Gdk.RGBA()
                {
                    red = 0.0, green = 0.0, blue = 1.0, alpha = 1.0
                });

            colors.@set(
                Color.BUS,
                Gdk.RGBA()
                {
                    red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0
                });

            colors.@set(
                Color.GRAPHIC,
                Gdk.RGBA()
                {
                    red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0
                });

            colors.@set(
                Color.TEXT,
                Gdk.RGBA()
                {
                    red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0
                });

            colors.@set(
                Color.ATTRIBUTE,
                Gdk.RGBA()
                {
                    red = 1.0, green = 1.0, blue = 0.0, alpha = 1.0
                });

            colors.@set(
                Color.DETACHED_ATTRIBUTE,
                Gdk.RGBA()
                {
                    red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0
                });

            colors.@set(
                Color.MAJOR_GRID,
                Gdk.RGBA()
                {
                    red = 0.125, green = 0.125, blue = 0.125, alpha = 1.0
                });

            colors.@set(
                Color.MINOR_GRID,
                Gdk.RGBA()
                {
                    red = 0.09, green = 0.09, blue = 0.09, alpha = 1.0
                });
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
                if (index == 0)
                {
                    color = Gdk.RGBA()
                    {
                        red   = 0.0,
                        green = 0.0,
                        blue  = 0.0,
                        alpha = 1.0
                    };
                }
                else
                {
                    color = Gdk.RGBA()
                    {
                        red   = 1.0,
                        green = 1.0,
                        blue  = 1.0,
                        alpha = 1.0
                    };
                }
            }

            return (!) color;
        }


        /**
         * Stores the colors for this color scheme
         */
        private Gee.HashMap<int,Gdk.RGBA?> colors;
    }
}
