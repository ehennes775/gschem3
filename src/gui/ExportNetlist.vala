namespace Gschem3
{
    /**
     * An operation to export schematics from the project
     */
    public class ExportNetlist : CustomAction
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
        public ExportNetlist(Gtk.Window? parent)
        {
            m_parent = parent;
        }


        /**
         * {@inheritDoc}
         */
        public override Action create_action()
        {
            var action = new SimpleAction(
                "export-netlist",
                null
                );

            bind_property(
                "enabled",
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


        /**
         * Create the export dialog
         */
        private Gtk.FileChooserDialog create_dialog()
        {
            var dialog = new ExportNetlistDialog();

            dialog.do_overwrite_confirmation = true;
            dialog.set_transient_for(m_parent);

            //dialog.set_current_folder(dirname);
            //dialog.set_current_name(DEFAULT_PRINT_FILENAME);

            return dialog;
        }
    }
}
