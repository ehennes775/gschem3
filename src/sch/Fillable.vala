namespace Geda3
{
    /**
     *
     */
    public interface Fillable : Object
    {
        /**
         * The fill style
         */
        public abstract FillStyle fill_style
        {
            get;
            construct set;
        }
    }
}
