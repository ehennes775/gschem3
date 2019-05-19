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
            SchematicWindow? window = null
            )
        {
            base(new TextFactory(), window);
        }
    }
}
