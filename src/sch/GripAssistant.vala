namespace Geda3
{
    /**
     *
     */
    public interface GripAssistant : Object
    {
        /**
         * Snap a point using the current snap mode
         *
         * The coordinates must be user coordinates.
         *
         * @param x The x coordinate to snap
         * @param y The y coordinate to snap
         */
        public abstract void snap_point(ref int x, ref int y);
    }
}
