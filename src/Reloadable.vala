namespace Gschem3
{
    /**
     *
     */
    public interface Reloadable : Object
    {
        /**
         * Indicates the document can be reloaded
         */
        public abstract bool can_reload
        {
            get;
            protected set;
        }

        /**
         * Indicates the file has changed since last loaded
         */
        public abstract bool modified
        {
            get;
            protected set;
        }

        /**
         * Reloads the document from the file
         *
         * @param window The transient parent for dialogs
         */
        public abstract void reload(Gtk.Window? parent) throws Error;
    }
}
