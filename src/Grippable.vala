namespace Geda3
{
    /**
     *
     */
    public interface Grippable : SchematicItem
    {
        /**
         *
         */
        public abstract Gee.Collection<Grip> create_grips();
    }
}
