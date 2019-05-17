namespace Gschem3
{
    /**
     *
     */
    public interface SchematicPasteHandler : Object
    {
        /**
         * Begin a paste operation
         *
         * @param x The reference x coordinate for positioning
         * @param y The reference y coordinate for positioning
         * @param items The items to paste
         */
        public abstract void paste(
            int x,
            int y,
            Gee.Collection<Geda3.SchematicItem> items
            );
    }
}
