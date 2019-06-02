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
        public abstract DocumentWindow? current_document_window
        {
            get;
            protected construct set;
        }
    }
}
