namespace Geda3
{
    /**
     * An interface for slotting mechanisms
     */
    public interface Slotter : Object
    {
        /**
         *
         *
         * @param items All schematic items making up the symbol
         * @param attributes The attributes to perform slotting on
         * @return The slotted attributes
         */
        public abstract Gee.List<SchematicItem> slot_attributes(
            Gee.Collection<SchematicItem> items,
            Gee.Collection<SchematicItem> attributes
            );
    }
}
