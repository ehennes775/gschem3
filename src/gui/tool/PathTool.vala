namespace Gschem3
{
    /**
     *
     */
    public class PathTool : DrawingTool
    {
        /**
         * The name of the tool for action parameters
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
