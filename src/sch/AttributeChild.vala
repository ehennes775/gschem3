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
         * The visibility of the attribute
         */
        public abstract Visibility visibility
        {
            get;
            construct set;
        }
    }
}
