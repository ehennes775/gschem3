namespace Geda3
{
    /**
     *
     */
    public interface AttributeChild : SchematicItem
    {
        /**
         * The color of the attribute
         */
        public abstract int color
        {
            get;
            construct set;
        }


        /**
         * The name of the attribute
         *
         * If the child does not represent an attribute, this property
         * is null. This would be the case if an attribute is converted
         * to just text.
         */
        public abstract string? name
        {
            get;
            protected set;
        }


        /**
         * The attribute value
         */
        public abstract string? @value
        {
            get;
            protected set;
        }


        /**
         * The visibility of the attribute
         */
        public abstract Visibility visibility
        {
            get;
            construct set;
        }


        /**
         * Set both the name and the value
         *
         * @param name The name of the attribute
         * @param value The attribute value
         */
        public abstract void set_pair(string name, string @value);
    }
}
