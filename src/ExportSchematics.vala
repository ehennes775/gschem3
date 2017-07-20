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
            default = false;
        }


        /**
         * Initialize the instance
         *
         * @param parent The parent window for dialog boxes
         */
        public ExportSchematics(Gtk.Window? parent)
        {
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
        }
    }
}
