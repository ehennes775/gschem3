namespace Geda3
{
    /**
     *
     */
    public interface PathCommandReceiver
    {
        /**
         *
         */
        public abstract void close_path();


        /**
         *
         */
        public abstract void line_to_absolute(int x, int y);


        /**
         *
         */
        public abstract void line_to_relative(int x, int y);


        /**
         *
         */
        public abstract void move_to_absolute(int x, int y);


        /**
         *
         */
        public abstract void move_to_relative(int x, int y);
    }
}
