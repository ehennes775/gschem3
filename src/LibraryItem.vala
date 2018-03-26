namespace Geda3
{
    /**
     * A base class for items in the symbol library
     */
    public abstract class LibraryItem : Object
    {
        /**
         * Indicates the appearance of the item has changed
         */
        public signal void item_changed();


        /**
         * Request a new item be inserted into the library tree
         *
         * @param parent The parent item
         * @param item The new item to insert
         */
        public signal void request_insertion(LibraryItem parent, LibraryItem item);


        /**
         * Request a refresh of the children of an item
         *
         * This function adds missing items from the tree and removes
         * deleted items from the tree.
         *
         * @param item The item requesting refresh
         */
        public signal void request_refresh(LibraryItem item);


        /**
         * A description of the item
         *
         * If the description is null, then the description is not
         * available at the moment, but should be at a later time.
         *
         * If the description is an empty string, then no description
         * is available for this item.
         */
        public abstract string? description
        {
            get;
            protected set;
        }


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
            notify["description"].connect(on_notify);
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
        public static bool is_renamable(LibraryItem item)
        {
            var renamable_item = item as Geda3.RenamableItem;

            return (
                (renamable_item != null) &&
                renamable_item.can_rename
                );
        }


        /**
         * Refresh the children of this node
         *
         * The base class provides this function to workaround Vala bug
         * 650836 -- delegates currently cannot be used as parameters
         * in signals.
         *
         * @param library The library needing refreshing
         */
        public virtual void perform_refresh(SymbolLibrary library)
        {
        }


        /**
         * Process a refresh on this node only
         */
        public virtual void refresh()
        {
            request_refresh(this);
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
