namespace Gschem3
{
    /**
     * The application window for the schematic editor
     */
    public class DocumentWindow : Gtk.Bin
    {
        /**
         * Initialize the instance
         */
        construct
        {
            tab = "Untitled";
        }


        public string tab
        {
            get;
            protected set;
        }
    }
}
