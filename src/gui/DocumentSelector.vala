namespace Gschem3
{
    /**
     *
     */
    public interface DocumentSelector : Object
    {
        /**
         *
         */
        public abstract DocumentWindow? document_window
        {
            get;
            protected construct set;
        }
    }
}
