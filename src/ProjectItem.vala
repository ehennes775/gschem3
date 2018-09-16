namespace Geda3
{
    /**
     * A base class for items in the project tree
     */
    public abstract class ProjectItem : Object
    {
        /**
         * Indicates the appearance of the item has changed
         */
        public signal void item_changed();


        /**
         * An icon to display next to the short name
         */
        public abstract ProjectIcon icon
        {
            get;
            protected set;
        }


        /**
         * A short name to appear in widgets
         */
        public abstract string tab
        {
            get;
            protected set;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            notify["icon"].connect(on_notify);
            notify["tab"].connect(on_notify);
        }


        /**
         * Determines if this item is renamable
         *
         * Currently, this function is static so it can be passed in
         * as a Predicate<G>.
         *
         * @param item The item to check if it can be renamed
         * @return This function returns true when this item is
         * renamable
         */
        public static bool is_renamable(ProjectItem item)
        {
            var renamable_item = item as Geda3.RenamableItem;

            return (
                (renamable_item != null) &&
                renamable_item.can_rename
                );
        }


        /**
         * Signal handler when a property changes
         *
         * This signal handler executes when a property that changes
         * the appearance of the item changes.
         */
        private void on_notify(ParamSpec param)
        {
            item_changed();
        }
    }
}
