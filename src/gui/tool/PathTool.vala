namespace Gschem3
{
    /**
     *
     */
    public class PathTool : DrawingTool
    {
        /**
         * The name of the tool as found in an action parameter
         */
        public const string NAME = "path";


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


        public PathTool(SchematicWindow? window = null)
        {
            base(window);
        }
    }
}
