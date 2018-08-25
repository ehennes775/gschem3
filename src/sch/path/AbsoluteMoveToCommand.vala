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
