namespace Geda3
{
    /**
     * Represents a line to path command with relative coordinates
     */
    public class RelativeLineToCommand : PathCommand
    {
        /**
         * The ID used in path strings
         */
        public const char ID = 'l';


        /**
         * Initilaze a new instance
         *
         * @param x The x coordinate parameter
         * @param y The y coordinate parameter
         */
        public RelativeLineToCommand(int x, int y)
        {
            b_x = x;
            b_y = y;
        }


        /**
         * {@inheritDoc}
         */
        public override void build_bounds(ref PathContext context, ref Bounds bounds)
        {
            var temp_bounds = new Bounds.with_points(
                context.current_x,
                context.current_y,
                context.current_x + b_x,
                context.current_x + b_y
                );

            bounds.union(temp_bounds);

            context.current_x += b_x;
            context.current_y += b_y;
        }


        /**
         * {@inheritDoc}
         */
        public override void put(PathCommandReceiver receiver)
        {
            receiver.line_to_relative(b_x, b_y);
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
