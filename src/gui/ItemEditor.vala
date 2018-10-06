namespace Gschem3
{
    public interface ItemEditor : Gtk.Widget
    {
        /**
         * Set the current document window for the editor
         *
         * @param window The current document window
         */
        public abstract void update_document_window(DocumentWindow? window);
    }
}
