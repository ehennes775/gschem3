namespace Geda3
{
    /**
     *
     */
    public interface AdjustableFillStyle : Object
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
