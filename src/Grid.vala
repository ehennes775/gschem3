namespace Gschem3
{
    /**
     *
     */
    public abstract class Grid : Object
    {
        /**
         * Initialize the class
         */
        static construct
        {
        }


        /**
         * Initialize the instance
         */
        construct
        {
        }


        /**
         *
         */
        public Grid()
        {
        }


        /**
         * Draw the grid
         *
         * @param context The context to use for drawing the grid
         */
        public abstract void draw(Cairo.Context context);
    }
}
