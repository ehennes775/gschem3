namespace Geda3
{
    /**
     * Abstract base class for manipulating items using grips
     */
    public abstract class Grip : Object
    {
        /**
         * Determines if the given point contacts the grip
         *
         * @param x The device x coordinate of the pointer
         * @param y The device y coordinate of the pointer
         * @param half_width The size of the grip
         * @return true if the point contacts the grip
         */
        public abstract bool contacts(
            double x,
            double y,
            double half_width
            );


        /**
         * Draw the grip
         *
         * @param painter The painter to use for drawing
         * @param half_width The size of the grip
         */
        public abstract void draw(
            SchematicPainter painter,
            double half_width
            );


        /**
         * End dragging the grip
         *
         * This function should only be called when the grip is
         * GRABBED.
         *
         * @param x The device x coordinate of the pointer
         * @param y The device y coordinate of the pointer
         */
        public abstract void drop(double x, double y);


        /**
         * Begin dragging the grip
         *
         * This function should be called when the grip is LOOSE.
         *
         * @param x The device x coordinate of the pointer
         * @param y The device y coordinate of the pointer
         */
        public abstract void grab(double x, double y);


        /**
         * Move the grip
         *
         * This function should only be called when the grip is
         * GRABBED.
         *
         * @param x The device x coordinate of the pointer
         * @param y The device y coordinate of the pointer
         */
        public abstract void move(double x, double y);


        /**
         * Initialize a new instance
         *
         * @param assistant Provides access to GUI functionality
         */
        protected Grip(GripAssistant assistant)
        {
            m_assistant = assistant;
        }


        /**
         * Provides access to functionality in the GUI
         */
        protected GripAssistant m_assistant;
    }
}
