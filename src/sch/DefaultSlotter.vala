namespace Geda3
{
    /**
     * A default slotting mechanism
     */
    public class DefaultSlotter : Object,
        Slotter
    {
        /**
         * {@inheritDoc}
         */
        public Gee.List<SchematicItem> slot_attributes(
            Gee.Collection<SchematicItem> items,
            Gee.Collection<SchematicItem> attributes
            )
        {
            var list = new Gee.ArrayList<SchematicItem>();

            list.add_all(attributes);

            return list;
        }
    }
}
