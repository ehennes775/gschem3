namespace Geda3
{
    /**
     * Represents a line to path command with absolute coordinates
     */
    public class AbsoluteLineToCommand : PathCommand,
        GrippablePoints
    {
        /**
         * The ID used in path strings
         */
        public const char ID = 'L';


        /**
         * Initilaze a new instance
         *
         * @param x The x coordinate parameter
         * @param y The y coordinate parameter
         */
        public AbsoluteLineToCommand(int x, int y)
        {
            b_x = x;
            b_y = y;
        }


        /**
         * {@inheritDoc}
         */
        public override void build_bounds(ref PathContext context, ref Bounds bounds)
        {
            var temp_bounds = Bounds.with_points(
                context.current_x,
                context.current_y,
                b_x,
                b_y
                );

            bounds.union(temp_bounds);

            context.current_x = b_x;
            context.current_y = b_y;
        }


        /**
         * {@inheritDoc}
         */
        public override void build_grips(Gee.List<Grip> grips)
        {
            grips.add(new PointGrip(this, 0));
        }


        /**
         * {@inheritDoc}
         */
        public void get_point(int index, out int x, out int y)
        {
            x = b_x;
            y = b_y;

            return_if_fail(index != 0);
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
            receiver.line_to_absolute(b_x, b_y);
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
        public void set_point(int index, int x, int y)

            requires(index == 0)

        {
            b_x = x;
            b_y = y;
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
