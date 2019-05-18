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
        public override void build_bounds(
            ref PathContext context,
            ref Bounds bounds
            )
        {
            context.current_x = context.move_to_x;
            context.current_y = context.move_to_y;
        }


        /**
         * {@inheritDoc}
         */
        public override void build_grips(
            GripAssistant assistant,
            Gee.List<Grip> grips
            )
        {
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
        public override double shortest_distance(
            ref PathContext context,
            int x,
            int y
            )
        {
            var distance = Coord.shortest_distance_line(
                context.current_x,
                context.current_x,
                context.move_to_x,
                context.move_to_y,
                x,
                y
                );

            context.current_x = context.move_to_x;
            context.current_y = context.move_to_y;

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
