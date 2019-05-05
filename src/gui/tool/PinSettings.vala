namespace Gschem3
{
    /**
     * Settings for the pin tool
     */
    public class PinSettings : Object
    {
        /**
         * The type of pin to create
         */
        public Geda3.PinType pin_type
        {
            get;
            set;
            default = Geda3.PinType.NET;
        }


        /**
         * Indicates pins should provide logic bubbles
         */
        public bool use_bubble
        {
            get;
            set;
            default = false;
        }


        /**
         * Create a new instance
         */
        public PinSettings()
        {
        }


        /**
         * Create a new bubble using these settings
         *
         * @param x The x coordinate of the center
         * @param y The y coordinate of the center
         * @return A circle item to use as a bubble or null if not
         * currently using bubbles
         */
        public Geda3.CircleItem? create_bubble(int x0, int y0, int x1, int y1)
        {
            Geda3.CircleItem? bubble = null;

            if (use_bubble)
            {
                bubble = new Geda3.CircleItem.as_bubble(x0, y0, x1, y1);
            }

            return bubble;
        }


        /**
         * Create a new pin using these settings
         *
         * @param x0 The x coordinate of the first point
         * @param y0 The y coordinate of the first point
         * @param x1 TODO add this parameter 
         * @param y1 TODO add this parameter
         * @return The new pin
         */
        public PinItemGroup create_pin(int x0, int y0)
        {
            return new PinItemGroup.standard(this, x0, y0);
        }


        /**
         * Get the default settings
         *
         * @return The default settings
         */
        public static PinSettings get_default()
        {
            if (s_default == null)
            {
                s_default = new PinSettings();
            }

            return s_default;
        }


        /**
         * The default settings
         */
        private static PinSettings s_default = null;
    }
}
