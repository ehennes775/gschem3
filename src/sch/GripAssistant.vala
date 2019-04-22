namespace Geda3
{
    /**
     * Provides a mechanism for grips to use functionality in the GUI
     * (dependency inversion).
     */
    public interface GripAssistant : Object
    {
        /**
         * Convert device coordinates to user coordinates
         *
         * @param dx The device x coordinate
         * @param dy The device y coordinate
         * @param ux The user x coordinate
         * @param uy The user y coordinate
         */
        public abstract void device_to_user(
            double dx,
            double dy,
            out int ux,
            out int uy
            );


        /**
         * Invalidate the graphical representation of a round grip.
         *
         * The coordinates must be device coordinates.
         *
         * @param x The x coordinate of the grip
         * @param y The y coordinate of the grip
         */
        public abstract void invalidate_round_grip(double x, double y);


        /**
         * Invalidate the graphical representation of a square grip
         *
         * The coordinates must be user coordinates.
         *
         * @param x The x coordinate of the grip
         * @param y The y coordinate of the grip
         */
        public abstract void invalidate_square_grip(int x, int y);


        /**
         * Snap an angle using the current snap mode
         *
         * @param angle The angle, in degrees
         * @return The snapped angle, in degrees
         */
        public abstract int snap_angle(int angle);


        /**
         * Snap a point using the current snap mode
         *
         * The coordinates must be user coordinates.
         *
         * @param x The x coordinate to snap
         * @param y The y coordinate to snap
         */
        public abstract void snap_point(ref int x, ref int y);


        /**
         * Convert user coordinates to device coordinates
         *
         * @param ux The user x coordinate
         * @param uy The user y coordinate
         * @param dx The device x coordinate
         * @param dy The device y coordinate
         */
        public abstract void user_to_device(
            double ux,
            double uy,
            out double dx,
            out double dy
            );
    }
}
