namespace Gschem3
{
    /**
     * The application window for the schematic editor
     */
    public abstract class DocumentWindow : Gtk.Bin
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


        /**
         *
         */
        public abstract void attach_actions(ActionMap map);


        /**
         *
         */
        public abstract void detach_actions(ActionMap map);
    }
}
