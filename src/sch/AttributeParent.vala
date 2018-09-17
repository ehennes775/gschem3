namespace Geda3
{
    /**
     * An interface for schematic items capable of having attributes
     */
    public interface AttributeParent : SchematicItem
    {
        /**
         * The attributes attached to this item
         */
        public signal void attached(AttributeChild child, AttributeParent parent);


        /**
         * The attributes attached to this item
         */
        public signal void detached(AttributeChild child, AttributeParent parent);


        /**
         * The attributes attached to this item
         */
        public abstract Gee.List<AttributeChild> attributes
        {
            owned get;
        }


        /**
         * Attach an attribute to this item
         *
         * @param attribute The attribute to attach
         */
        public abstract void attach(AttributeChild attribute);
    }
}
