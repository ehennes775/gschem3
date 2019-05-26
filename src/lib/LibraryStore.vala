namespace Geda3
{
    /**
     *
     */
    public class LibraryStore : Object,
        SymbolLibraryBase
    {
        /**
         * The object contributing symbols at the project level
         */
        public LibraryContributor? project_contributor
        {
            get
            {
                return b_project_contributor;
            }
            set
            {
                if (b_project_contributor != null)
                {
                    remove_contributor(b_project_contributor);
                }

                b_project_contributor = value;

                if (b_project_contributor != null)
                {
                    add_contributor(b_project_contributor);
                }
            }
        }


        /**
         * The object contributing symbols at the system level
         */
        public LibraryContributor? system_contributor
        {
            get
            {
                return b_system_contributor;
            }
            set
            {
                if (b_system_contributor != null)
                {
                    remove_contributor(b_system_contributor);
                }

                b_system_contributor = value;

                if (b_system_contributor != null)
                {
                    add_contributor(b_system_contributor);
                }
            }
        }


        /**
         * Initialize the instance
         */
        construct
        {
        }


        /**
         * {@inheritDoc}
         */
        public int child_position(void* child)

            requires(child != null)

        {
            var temp_child = (Node<LibraryItem>*) child;

            return_val_if_fail(temp_child->parent != null, -1);

            return temp_child->parent.child_position(temp_child);
        }


        /**
         * {@inheritDoc}
         */
        public string get_description(void* node)
        {
            var temp_node = (Node<LibraryItem>*) node;

            var item = temp_node->data;

            return_val_if_fail(item != null, "");

            return item.description ?? "";
        }


        /**
         * {@inheritDoc}
         */
        public Geda3.ProjectIcon get_icon(void* node)
        {
            var temp_node = (Node<LibraryItem>*) node;

            var item = temp_node->data;

            return_val_if_fail(item != null, false);

            return item.icon;
        }


        /**
         * {@inheritDoc}
         */
        public LibraryItem get_item(void* node)
        {
            var temp = (Node<LibraryItem>*) node ?? m_root;

            return temp->data;
        }


        /**
         * {@inheritDoc}
         */
        public string get_name(void* node)
        {
            var temp_node = (Node<LibraryItem>*) node;

            var item = temp_node->data;

            return_val_if_fail(item != null, false);

            return item.tab;
        }


        /**
         * {@inheritDoc}
         */
        public void* get_parent(void* child)

            requires(child != null)

        {
            var temp_child = (Node<LibraryItem>*) child;

            return temp_child->parent;

        }


        /**
         * {@inheritDoc}
         */
        public bool get_renamable(void* node)

            requires(node != null)

        {
            var temp_node = (Node<LibraryItem>*) node;

            var item = temp_node->data;

            return_val_if_fail(item != null, false);

            return Geda3.LibraryItem.is_renamable(item);
        }


        /**
         * {@inheritDoc}
         */
        public bool is_leaf(void *node)
        {
            var temp = (Node<LibraryItem>*) node ?? m_root;

            return temp->is_leaf();
        }


        /**
         * {@inheritDoc}
         */
        public int n_children(void *parent)
        {
            var temp = (Node<LibraryItem>*) parent ?? m_root;

            return (int)temp->n_children();
        }


        /**
         * {@inheritDoc}
         */
        public void* next_sibling(void *node)

            requires(node != null)

        {
            var temp_node = (Node<LibraryItem>*) node;

            return temp_node->next_sibling();
        }


        /**
         * {@inheritDoc}
         */
        public void* nth_child(void* parent, int index)
        {
            var temp = (Node<LibraryItem>*) parent ?? m_root;

            return temp->nth_child(index);
        }


        /**
         * A dummy library item to use in the root node
         *
         * This dummy item allows the node to use a non-nullable type.
         */
        // TODO: create a dummy library item
        private static LibraryItem s_dummy = null;


        /**
         * The backing store for the project symbol contributor
         */
        private LibraryContributor? b_project_contributor = null;


        /**
         * The backing store for the system symbol contributor
         */
        private LibraryContributor? b_system_contributor = null;


        private Gee.Map<LibraryItem,unowned Node<LibraryItem>> m_index =
            new Gee.HashMap<LibraryItem,unowned Node<LibraryItem>>();


        /**
         * The root node in the library tree
         *
         * Children of the root node store the contributors. Data
         * inside the root node is ignored.
         */
        private Node<LibraryItem> m_root = new Node<LibraryItem>(
            s_dummy
            );


        /**
         *
         */
        private void add_contributor(LibraryContributor contributor)

            requires(m_root != null)

        {
            //var item = new wrapper(contributor);

            //unowned Node<LibraryItem> item_node = m_root.append(
            //    new Node<LibraryItem>(item)
            //    );
        }


        /**
         * 
         *
         * @param item The item that underwent changes
         */
        private void on_item_changed(LibraryItem item)

            requires(m_index != null)

        {
            unowned Node<LibraryItem>? node = m_root.find(
                TraverseType.LEVEL_ORDER,
                TraverseFlags.ALL,
                item
                );

            return_if_fail(node != null);

            node_changed(node);
        }


        /**
         * Remove a contributor from the library
         *
         * @param contributor The contributor to remove
         */
        private void remove_contributor(LibraryContributor contributor)

            requires(m_root != null)

        {
            unowned Node<LibraryItem>? item_node = m_root.find_child(
                TraverseFlags.ALL,
                null //wrapper
                );

            if (item_node != null)
            {
                var index = m_root.child_position(item_node);

                var item_tree = item_node.unlink();

                node_removed(m_root, index);

                item_tree.traverse(
                    TraverseType.POST_ORDER,
                    TraverseFlags.ALL,
                    -1,
                    (node) =>
                    {
                        var temp_node = (Node<LibraryItem>*)node;

                        temp_node->data.item_changed.disconnect(
                            on_item_changed
                            );

                        m_index.unset(temp_node->data);

                        return false;
                    }
                    );
            }
        }
    }
}
