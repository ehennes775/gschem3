namespace Geda3
{
    /**
     * Represents a move to path command with absolute coordinates
     */
    public class AbsoluteMoveToCommand : PathCommand
    {
        /**
         * The ID used in path strings
         */
        public const char ID = 'M';


        /**
         * Initilaze a new instance
         *
         * @param x The x coordinate parameter
         * @param y The y coordinate parameter
         */
        public AbsoluteMoveToCommand(int x, int y)
        {
            b_x = x;
            b_y = y;
        }


        /**
         * {@inheritDoc}
         */
        public override void build_bounds(ref PathContext context, ref Bounds bounds)
        {
            context.current_x = b_x;
            context.current_y = b_y;
            context.move_to_x = b_x;
            context.move_to_y = b_y;
        }


        /**
         * {@inheritDoc}
         */
        public override void put(PathCommandReceiver receiver)
        {
            receiver.move_to_absolute(b_x, b_y);
        }


        /**
         * {@inheritDoc}
         */
        public override string to_path_string()
        {
            return @"$(ID) $(b_x),$(b_y)";
        }


        /**
         * The backing store for the x coordinate
         */
        private int b_x = 0;


        /**
         * The backing store for the y coordinate
         */
        private int b_y = 0;
    }
}
