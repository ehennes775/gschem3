namespace Geda3
{
    /**
     * An interface for schematic items that can change color
     */
    public interface AdjustableColor : SchematicItem
    {
        /**
         * The color index
         */
        public abstract int color
        {
            get;
            construct set;
        }
    }
}
