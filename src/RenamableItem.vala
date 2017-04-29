namespace Geda3
{
    /**
     * A base class for items in the project tree
     */
    public interface RenamableItem : Object
    {
        /**
         * Indicates this item can be renamed
         */
        public abstract bool can_rename
        {
            get;
            protected set;
        }


        /**
         * Indicates this item can be renamed
         */
        public abstract void rename(string new_name) throws Error;
    }
}
