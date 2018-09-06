namespace Geda3
{
    /**
     *
     */
    public interface AttributeChild : SchematicItem
    {
        public abstract string? name
        {
            get;
            protected set;
        }
    }
}
