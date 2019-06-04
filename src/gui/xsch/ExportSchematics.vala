namespace Gschem3
{
    /**
     * An operation to export schematics from the project
     */
    public class ExportSchematics : Object,
        ActionProvider
    {
        /**
         * Initialize the instance
         */
        construct
        {
            m_export_schematics_action.activate.connect(on_activate);
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
         * {@inheritDoc}
         */
        public void add_actions_to(ActionMap map)
        {
            map.add_action(m_export_schematics_action);
        }


        /**
         *
         */
        private SimpleAction m_export_schematics_action = new SimpleAction(
            "export-schematics",
            null
            );


        /**
         * The transient parent window for dialog boxes
         */
        private Gtk.Window? m_parent;


        /**
         * Create the export dialog
         */
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


        /**
         * Perform the operation
         *
         * @param parameter Unused
         */
        private void on_activate(Variant? parameter)
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
    }
}
