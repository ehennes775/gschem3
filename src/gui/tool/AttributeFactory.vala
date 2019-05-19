namespace Gschem3
{
    /**
     * Creates detached attributes for the placement tool
     */
    public class AttributeFactory : PlacementFactory
    {
        /**
         * {@inheritDoc}
         */
        public override Geda3.TextItem create_item(int x, int y)
        {
            return new Geda3.TextItem.as_attribute(
                x,
                y,
                "name",
                "value",
                Geda3.Visibility.VISIBLE,
                Geda3.TextPresentation.BOTH,
                Geda3.TextAlignment.LOWER_LEFT,
                0,
                Geda3.Color.ATTRIBUTE,
                10
                );
        }
    }
}
