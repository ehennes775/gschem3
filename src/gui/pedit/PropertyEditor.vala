namespace Gschem3
{
    /**
     *
     */
    public abstract class PropertyEditor : Gtk.Expander, ItemEditor
    {
        /**
         * The schematic window containing the current selection
         *
         * If null, there is no current window, or the current window
         * is not editing a schmeatic.
         */
        public SchematicWindow? schematic_window
        {
            get
            {
                return b_schematic_window;
            }
            construct set
            {
                if (b_schematic_window != null)
                {
                    b_schematic_window.selection_changed.disconnect(
                        on_selection_change
                        );
                }

                b_schematic_window = value;

                if (b_schematic_window != null)
                {
                    b_schematic_window.selection_changed.connect(
                        on_selection_change
                        );
                }
            }
            default = null;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            notify["schematic-window"].connect(
                on_notify_schematic_window
                );
        }


        /**
         * {@inheritDoc}
         */
        public void update_document_window(DocumentWindow? window)
        {
            schematic_window = window as SchematicWindow;
        }


        /**
         * The backing store for the schematic window property
         */
        protected SchematicWindow? b_schematic_window;


        /**
         * Update all the values in the UI
         */
        protected abstract void update();


        /**
         * Signal handler when the current window changes
         *
         * @param param Unused
         */
        private void on_notify_schematic_window(ParamSpec param)
        {
            update();
        }


        /**
         *
         */
        public void on_selection_change()
        {
            update();
        }
    }
}
