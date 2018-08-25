namespace Geda3
{
    /**
     *
     */
    public class AbsoluteMoveToCommand : PathCommand
    {
        /**
         *
         */
        public const char ID = 'M';


        public AbsoluteMoveToCommand(int x, int y)
        {
            b_x = x;
            b_y = y;
        }


        /**
         * {@inheritDoc}
         */
        public override void put(PathCommandReceiver receiver)
        {
            receiver.move_to_absolute(b_x, b_y);
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
