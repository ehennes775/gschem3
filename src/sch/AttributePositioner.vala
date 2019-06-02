namespace Geda3
{
    /**
     *
     */
    public abstract interface AttributePositioner : Object
    {
        /**
         * Adjust the positioning of an attribute on a bus or net
         *
         * @param x0
         * @param y0
         * @param x1
         * @param y1
         * @param item
         */
        public abstract void adjust_bus_net(
            int x0,
            int y0,
            int x1,
            int y1,
            TextItem item
            );
    }
}
