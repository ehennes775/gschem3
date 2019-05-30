namespace Gschem3
{
    /**
     *
     */
    //[GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/MainWindow.ui.xml")]
    public class DocumentWindowNotebook : Gtk.Notebook
    {
        /**
         *
         */
        public void add_document_window(DocumentWindow window)
        {
                window.show_all();
                var tab = new DocumentTab(window);
                tab.show_all();

                append_page(window, tab);
        }
    }
}
