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
        public signal void attached(
            AttributeChild child,
            AttributeParent parent
            );


        /**
         * The attributes attached to this item
         */
        public signal void detached(
            AttributeChild child,
            AttributeParent parent
            );


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


        /**
         * Detach an attribute from this item
         *
         * @param attribute The attribute to detach
         */
        public abstract void detach(AttributeChild attribute);


        /**
         * Signal handler for forwarding invalidate signals
         */
        protected void on_invalidate(SchematicItem item)
        {
            invalidate(item);
        }


        /**
         * Signal handlerfor forwarding attribute changed
         */
        protected void on_notify_attribute(
            Object sender,
            ParamSpec param
            )
        {
            attribute_changed(sender as AttributeChild, this);
        }
    }
}
