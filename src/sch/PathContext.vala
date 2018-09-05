namespace Geda3
{
    /**
     *
     */
    public struct PathContext
    {
        /**
         *
         */
        int current_x;


        /**
         *
         */
        int current_y;


        /**
         *
         */
        int move_to_x;


        /**
         *
         */
        int move_to_y;


        /**
         * Create an empty bounds
         */
        public PathContext()
        {
            current_x = 0;
            current_y = 0;
            move_to_x = 0;
            move_to_y = 0;
        }
    }
}
