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
    }
}
