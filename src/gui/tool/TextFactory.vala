namespace Gschem3
{
    /**
     * Creates text items for the placement tool
     */
    public class TextFactory : PlacementFactory
    {
        /**
         * {@inheritDoc}
         */
        public override Geda3.TextItem create_item(int x, int y)
        {
            var text = new Geda3.TextItem();

            text.x = x;
            text.y = y;

            return text;
        }
    }
}
