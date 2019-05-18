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
        public override void advance_context(ref PathContext context)
        {
            context.current_x = b_x;
            context.current_y = b_y;
            context.move_to_x = b_x;
            context.move_to_y = b_y;
        }


        /**
         * {@inheritDoc}
         */
        public override void build_bounds(
            ref PathContext context,
            ref Bounds bounds
            )
        {
            advance_context(ref context);
        }


        /**
         * {@inheritDoc}
         */
        public override void build_grips(
            GripAssistant assistant,
            PathItem parent,
            int command_index,
            Gee.List<Grip> grips
            )
        {
            grips.add(new PathPointGrip(
                assistant,
                parent,
                command_index,
                0
                ));
        }


        /**
         * {@inheritDoc}
         */
        public override void get_point(
            ref PathContext context,
            int index,
            out int x,
            out int y
            )
        {
            x = b_x;
            y = b_y;

            return_if_fail(index == 0);
        }


        /**
         * {@inheritDoc}
         */
        public override bool locate_insertion_point(
            ref PathContext context,
            out int x,
            out int y
            )
        {
            x = b_x;
            y = b_y;

            advance_context(ref context);

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_x(int cx)
        {
            b_x = 2 * cx - b_x;
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_y(int cy)
        {
            b_y = 2 * cy - b_y;
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
        public override void rotate(int cx, int cy, int angle)
        {
            Coord.rotate(cx, cy, angle, ref b_x, ref b_y);
        }


        /**
         * {@inheritDoc}
         */
        public override void set_point(
            ref PathContext context,
            int index,
            int x,
            int y
            )

            requires(index == 0)

        {
            b_x = x;
            b_y = y;
        }


        /**
         * {@inheritDoc}
         */
        public override double shortest_distance(
            ref PathContext context,
            int x,
            int y
            )
        {
            var distance = Coord.distance(
                b_x,
                b_y,
                x,
                y
                );

            advance_context(ref context);

            return distance;
        }


        /**
         * {@inheritDoc}
         */
        public override string to_path_string()
        {
            return @"$(ID) $(b_x),$(b_y)";
        }


        /**
         * {@inheritDoc}
         */
        public override void translate(int dx, int dy)
        {
            b_x += dx;
            b_y += dy;
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
