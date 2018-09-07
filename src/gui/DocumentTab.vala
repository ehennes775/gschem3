namespace Gschem3
{
    /**
     * Provides a widget to act as a notebook tab for a document window
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/DocumentTab.ui.xml")]
    public class DocumentTab : Gtk.Grid
    {
        /**
         * Initialize the instance
         */
        construct
        {
        }


        /**
         * Initialize the instance
         *
         * @param window The document window that this tab represents
         */
        public DocumentTab(DocumentWindow window)
        {
            window.bind_property(
                "tab",
                name_label,
                "label",
                BindingFlags.SYNC_CREATE
                );

            if (window is Reloadable)
            {
                window.bind_property(
                    "modified",
                    modified_label,
                    "visible",
                    BindingFlags.SYNC_CREATE
                    );
            }

            if (window is Savable)
            {
                window.bind_property(
                    "changed",
                    changed_label,
                    "visible",
                    BindingFlags.SYNC_CREATE
                    );
            }
        }


        /**
         * Indicates the document has changed since last saved
         *
         * Setting this widget to visible indicates the document in the window
         * has changed since last saved.
         */
        [GtkChild(name="changed-label")]
        private Gtk.Label changed_label;


        /**
         * Indicates the document file has been modified since last loaded
         *
         * Setting this widget to visible indicates the file of the document
         * in the window has been modified since last loaded.
         */
        [GtkChild(name="modified-label")]
        private Gtk.Image modified_label;


        /**
         * Shows a short name for the doucment in the notebook tab
         */
        [GtkChild(name="name-label")]
        private Gtk.Label name_label;
    }
}
