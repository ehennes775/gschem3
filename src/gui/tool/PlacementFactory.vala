namespace Gschem3
{
    /**
     * Creates items for the placement tool
     */
    public abstract class PlacementFactory : Object
    {
        /**
         * Create an item
         *
         * The arguments are in user coordinates.
         *
         * @param x The x coordinate of the initial placement
         * @param y The y coordinate of the initial placement
         */
        public abstract Geda3.TextItem create_item(int x, int y);
    }
}
