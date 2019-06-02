namespace Geda3
{
    /**
     * An interface for schematic items capable of creating attributes
     */
    public interface AttributeCreator : SchematicItem,
        AttributeParent
    {
        /**
         * Indicates an attribute can be created and attached
         */
        public abstract bool can_create_and_attach
        {
            get;
        }


        /**
         * Create and attach a new child attribute
         *
         * @param name The name of the attribute
         * @param value The value of the attribute
         * @param presentation The attribute presentation
         * @param visibility The attribute visibility
         * @return The new attribute both created and attached
         */
        public abstract AttributeChild create_and_attach(
            AttributePositioner positioner,
            string name,
            string @value,
            TextPresentation presentation,
            Visibility visibility
            );
    }
}
