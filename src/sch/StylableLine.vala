namespace Geda3
{
    /**
     *
     */
    public interface StylableLine : Object
    {
        /**
         * The line style
         */
        public abstract LineStyle line_style
        {
            get;
            construct set;
        }


        /**
         * The line width
         */
        public abstract int width
        {
            get;
            construct set;
        }
    }
}
