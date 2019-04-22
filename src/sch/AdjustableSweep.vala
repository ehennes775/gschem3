namespace Geda3
{
    /**
     * An interface for schematic items with an adjustable sweep
     */
    public interface AdjustableSweep : SchematicItem
    {
        /**
         * The starting angle of the sweep in degrees
         */
        public abstract int start_angle
        {
            get;
            construct set;
        }


        /**
         * The sweep angle in degrees
         */
        public abstract int sweep_angle
        {
            get;
            construct set;
        }
    }
}
