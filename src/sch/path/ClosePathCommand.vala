namespace Geda3
{
    /**
     *
     */
    public class ClosePathCommand : PathCommand
    {
        /**
         * The ID used in path strings
         *
         * The close path command can either be upper or lower case.
         */
        public const char ID = 'z';


        /**
         * Initilaze a new instance
         */
        public ClosePathCommand()
        {
        }


        /**
         * {@inheritDoc}
         */
        public override void build_bounds(ref PathContext context, ref Bounds bounds)
        {
        }


        /**
         * {@inheritDoc}
         */
        public override void build_grips(Gee.List<Grip> grips)
        {
        }


        /**
         * {@inheritDoc}
         */
        public override void put(PathCommandReceiver receiver)
        {
            receiver.close_path();
        }

        /**
         * {@inheritDoc}
         */
        public override string to_path_string()
        {
            return @"$(ID)";
        }


        /**
         * {@inheritDoc}
         */
        public override void translate(int dx, int dy)
        {
        }
    }
}
