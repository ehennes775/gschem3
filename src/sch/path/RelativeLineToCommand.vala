namespace Geda3
{
    /**
     *
     */
    public class RelativeLineToCommand : PathCommand
    {
        /**
         *
         */
        public const char ID = 'l';


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
