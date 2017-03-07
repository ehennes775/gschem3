namespace Gschem3
{
    /**
     *
     */
    public interface Savable : Object
    {
        /**
         * Indicates the document has changed since last saved
         */
        public abstract bool changed
        {
            get;
            protected set;
        }

        /**
         *
         */
        public abstract void save() throws Error;


        /**
         *
         */
        public abstract void save_as() throws Error;
    }
}
