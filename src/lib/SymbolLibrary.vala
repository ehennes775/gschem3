namespace Geda3
{
    /**
     * A base class for objects providing symbol library browsing
     */
    public abstract interface SymbolLibrary : Object
    {
        /**
         * Indicates a node changed in the library
         *
         * @param node The new node inserted into the library
         */
        public signal void node_changed(void* node);


        /**
         * Indicates a new node inserted into the library
         *
         * @param node The new node inserted into the library
         */
        public signal void node_inserted(void* node);


        /**
         * Indicates a node has been removed from the library
         *
         * @param parent The parent of the removed node
         * @param index The location of the node before removal
         */
        public signal void node_removed(void* parent, int index);


        /**
         * Returns index of the child
         *
         * @param child The child to determince the index of
         */
        public abstract int child_position(void* child);


        /**
         * Returns a description for this node
         *
         * @param node The iterator for the node
         */
        public abstract string get_description(void* node);


        /**
         * Returns an icon for this node
         *
         * @param node The iterator for the node
         */
        public abstract Geda3.ProjectIcon get_icon(void* node);


        /**
         * Returns the item for this node
         *
         * @param node The iterator for the node
         */
        public abstract LibraryItem get_item(void* node);


        /**
         * Returns a name for this node
         *
         * @param node The iterator for the node
         */
        public abstract string get_name(void* node);


        /**
         * Returns the parent node
         *
         * @param child The child node
         */
        public abstract void* get_parent(void* child);


        /**
         * Returns if the node contains a renamable item
         *
         * @param node The node to test for renamability
         */
        public abstract bool get_renamable(void* node);


        /**
         * Is the given node a leaf node
         *
         * @param node The node to test
         */
        public abstract bool is_leaf(void *node);


        /**
         * Get the number of children of a parent
         *
         * @param parent The iterator for the parent
         */
        public abstract int n_children(void *parent);


        /**
         *
         */
        public abstract void* next_sibling(void *node);


        /**
         *
         */
        public abstract void* nth_child(void* parent, int index);


        /**
         *
         */
        public abstract void* find_item(LibraryItem item);


        /**
         *
         */
        public abstract void remove_node(void* node);
    }
}
