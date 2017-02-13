namespace Geda3
{
    /**
     *
     */
    public interface AttributeParent : SchematicItem
    {
        public abstract Gee.LinkedList<AttributeChild> attributes
        {
            get;
        }

        /**
         * Attach an attribute to this item
         *
         * @param attribute The attribute to attach
         */
        public abstract void attach(AttributeChild attribute);
    }
}
