namespace Gschem3
{
    /**
     * An interface for document windows that can save contents to a
     * file
     */
    public interface Savable : Object, Fileable
    {
        /**
         * Indicates the document has changed since last saved
         */
        public abstract bool changed
        {
            get;
            protected set;
        }

        /**
         * Save the document in the window
         *
         * @param window The transient parent for dialogs
         */
        public abstract void save(Gtk.Window? parent) throws Error;


        /**
         * Save the document in the window with another filename
         *
         * @param window The transient parent for dialogs
         */
        public abstract void save_as(Gtk.Window? parent) throws Error;
    }
}
