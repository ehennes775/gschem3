namespace Gschem3
{
    /**
     * An operation to export schematics from the project
     */
    public class ExportSchematics : Object
    {
        /**
         * Indicates the opeartion is enabled
         */
        public bool can_activate
        {
            get;
            private set;
            default = true;
        }


        /**
         * Initialize the instance
         *
         * @param parent The parent window for dialog boxes
         */
        public ExportSchematics(Gtk.Window? parent)
        {
            m_parent = parent;
        }


        /**
         * Create an action for this operation
         */
        public Action create_action()
        {
            var action = new SimpleAction(
                "export-schematics",
                null
                );

            bind_property(
                "can-activate",
                action,
                "enabled",
                BindingFlags.SYNC_CREATE
                );

            action.activate.connect(activate);

            return action;
        }


        /**
         * Perform the operation
         *
         * @param parameter Unused
         */
        public void activate(Variant? parameter)
        {
            Gtk.FileChooserDialog dialog = null;

            try
            {
                dialog = create_dialog();

                var result = dialog.run();

                if (result == Gtk.ResponseType.OK)
                {
                }
            }
            catch (Error error)
            {
            }
            finally
            {
                if (dialog != null)
                {
                    dialog.destroy();
                }
            }
        }


        /**
         * The transient parent window for dialog boxes
         */
        private Gtk.Window? m_parent;


        private Gtk.FileChooserDialog create_dialog()
        {
            var dialog = new Gtk.FileChooserDialog(
                "Export Schematics",
                m_parent,
                Gtk.FileChooserAction.SAVE,
                "_Cancel", Gtk.ResponseType.CANCEL,
                "_OK",     Gtk.ResponseType.OK,
                null
                );

            dialog.do_overwrite_confirmation = true;

            //dialog.set_current_folder(dirname);
            //dialog.set_current_name(DEFAULT_PRINT_FILENAME);

            return dialog;
        }
    }
}
