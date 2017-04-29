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
    }
}
