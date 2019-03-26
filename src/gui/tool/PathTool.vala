namespace Gschem3
{
    /**
     *
     */
    public class PathTool : DrawingTool
    {
        /**
         *
         */
        public const string NAME = "path";


        /**
         *
         */
        public override string name
        {
            get
            {
                return NAME;
            }
        }


        public PathTool(SchematicWindow? window)
        {
            base(window);
        }
    }
}
