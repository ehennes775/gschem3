namespace Geda3
{
    /**
     * Provides an abstract base class for promoting attributes
     */
    public abstract class AttributePromoter : Object
    {
        /**
         * Select promoted attributes
         *
         * @param items The top level items in the symbol
         * @return A list of the promoted attributes
         */
        public abstract Gee.List<AttributeChild> promote(Gee.Collection<SchematicItem> items);
    }
}
