namespace Gschem3
{
    /**
     * Places text items onto a schematic
     */
    public class TextTool : PlacementTool
    {
        /**
         * The name of the tool for action parameters
         */
        public const string NAME = "text";


        /**
         * {@inheritDoc}
         */
        public override string name
        {
            get
            {
                return NAME;
            }
        }


        /**
         * Create a new unattached attribute drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public TextTool(
            Gtk.Window parent,
            SchematicWindow? window = null
            )
        {
            base(new TextFactory(), window);

            m_parent = parent;
        }


        /**
         * The transient parent for dialog boxes
         */
        private Gtk.Window m_parent;


        /**
         * {@inheritDoc}
         */
        protected override bool edit_item(Geda3.TextItem item)
        {
            var dialog = new TextEditorDialog();

            dialog.set_transient_for(m_parent);
            dialog.item = item;

            var result = dialog.run();

            dialog.destroy();

            return result == Gtk.ResponseType.OK;
        }
    }
}
