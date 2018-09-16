namespace Geda3
{
    /**
     *
     */
    public interface AttributeChild : SchematicItem
    {
        /**
         *
         */
        public abstract int color
        {
            get;
            construct set;
        }


        /**
         *
         */
        public abstract string? name
        {
            get;
            protected set;
        }
    }
}
