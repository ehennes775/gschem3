namespace Geda3
{
    /**
     * A base class for items in the project tree
     */
    public interface RemovableItem : Object
    {
        /**
         * Indicates this item can be removed from persistence
         */
        public abstract bool can_remove
        {
            get;
            protected set;
        }


        /**
         * Removes this item from storage
         */
        public abstract void remove();
    }
}
