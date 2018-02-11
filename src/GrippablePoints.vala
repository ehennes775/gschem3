namespace Geda3
{
    /**
     *
     */
    public interface GrippablePoints : Object
    {
        /**
         *
         */
        public abstract void get_point(int index, out int x, out int y);


        /**
         *
         */
        public abstract void set_point(int index, int x, int y);
    }
}
