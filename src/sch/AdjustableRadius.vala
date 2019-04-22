namespace Geda3
{
    /**
     * An interface for schematic items with an adjustable radius
     */
    public interface AdjustableRadius : SchematicItem
    {
        /**
         * The x coordinate of the center of the item
         */
        public abstract int center_x
        {
            get;
        }


        /**
         * The y coordinate of the center of the item
         */
        public abstract int center_y
        {
            get;
        }


        /**
         * The radius
         */
        public abstract int radius
        {
            get;
            construct set;
        }
    }
}
