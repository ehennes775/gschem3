namespace Gschem3
{
    /**
     *
     */
    public interface SchematicPasteHandler : Object
    {
        /**
         *
         */
        public abstract void paste(
            Gee.Collection<Geda3.SchematicItem> items
            );
    }
}
