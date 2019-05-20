namespace Gschem3
{
    /**
     * Places detached attributes onto a schematic
     */
    public class AttributeTool : PlacementTool
    {
        /**
         * The name of the tool for action parameters
         */
        public const string NAME = "attribute";


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
        public AttributeTool(
            SchematicWindow? window = null
            )
        {
            base(new AttributeFactory(), window);
        }


        /**
         * {@inheritDoc}
         */
        protected override bool edit_item(Geda3.TextItem item)
        {
            var dialog = new TextEditorDialog();

            var result = dialog.run();

            dialog.destroy();

            return result == Gtk.ResponseType.OK;
        }
    }
}
