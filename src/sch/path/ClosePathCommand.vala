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
        public override void advance_context(ref PathContext context)
        {
            context.current_x = context.move_to_x;
            context.current_y = context.move_to_y;
        }


        /**
         * {@inheritDoc}
         */
        public override void build_bounds(
            ref PathContext context,
            ref Bounds bounds
            )

            requires(context.initial_move)

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
            assert_not_reached();
        }


        /**
         * {@inheritDoc}
         */
        public override bool locate_insertion_point(
            ref PathContext context,
            out int x,
            out int y
            )

            requires(context.initial_move)

        {
            x = int.min(
                context.current_x,
                context.move_to_x
                );

            y = int.min(
                context.current_y,
                context.move_to_y
                );

            advance_context(ref context);

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_x(int cx)
        {
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_y(int cy)
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
        public override void rotate(int cx, int cy, int angle)
        {
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
        {
            assert_not_reached();
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
            return_val_if_fail(context.initial_move, double.MAX);

            var distance = Coord.shortest_distance_line(
                context.current_x,
                context.current_y,
                context.move_to_x,
                context.move_to_y,
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
