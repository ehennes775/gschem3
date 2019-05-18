namespace Geda3
{
    /**
     *
     */
    public struct PathContext
    {
        /**
         * The current absolute x coordinate
         */
        int current_x;


        /**
         * The current absolute y coordinate
         */
        int current_y;


        /**
         * Indicates the presence of the initial absolute move to
         * command
         *
         * An initial absolute move to command must be the first
         * command in the sequence. Subsequent commands can check this
         * value.
         */
        bool initial_move;


        /**
         * The absolute x coordinate of the last move to command
         *
         * The close path command needs this value.
         */
        int move_to_x;


        /**
         * The absolute y coordinate of the last move to command
         *
         * The close path command needs this value.
         */
        int move_to_y;


        /**
         * Create an initial path context
         */
        public PathContext()
        {
            initial_move = false;

            current_x = 0;
            current_y = 0;
            move_to_x = 0;
            move_to_y = 0;
        }
    }
}
