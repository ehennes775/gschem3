namespace Gschem3
{
    /**
     * An operation to export a bill of material from the project
     */
    public class ExportBillOfMaterial : CustomAction
    {
        /**
         * Indicates the opeartion is enabled
         */
        public bool enabled
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
        public ExportBillOfMaterial(Gtk.Window? parent)
        {
            m_parent = parent;

            var temp_action = new SimpleAction(
                "export-bill-of-material",
                null
                );

            bind_property(
                "enabled",
                temp_action,
                "enabled",
                BindingFlags.SYNC_CREATE
                );

            temp_action.activate.connect(activate);

            action = temp_action;
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


        /**
         * Create the export dialog
         */
        private Gtk.FileChooserDialog create_dialog()
        {
            var dialog = new ExportBillOfMaterialDialog();

            dialog.do_overwrite_confirmation = true;
            dialog.set_transient_for(m_parent);

            //dialog.set_current_folder(dirname);
            //dialog.set_current_name(DEFAULT_PRINT_FILENAME);

            return dialog;
        }
    }
}
