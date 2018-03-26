namespace Geda3
{
    /**
     * Schematic symbol libraries
     */
    public class SymbolLibrary
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



        public signal void symbol_used(Symbol symbol);
        public signal void symbol_unused(string name);


        public SymbolLibrary()
        {
            m_root = new Node<LibraryItem>(s_dummy);

            m_names = new Gee.HashMap<void*,string>();
            m_symbols = new Gee.HashMap<string,weak Symbol>();

            // add some data for testing

            var folder = new LibraryFolder(File.new_for_path("/home/ehennes/Projects/testlib/symbols"));

            folder.request_insertion.connect(on_request_insertion);
            folder.request_refresh.connect(on_request_refresh);
            folder.request_update.connect(on_request_update);

            unowned Node<LibraryItem> folder_node = m_root.append(new Node<LibraryItem>(
                folder
                ));

            folder.refresh();
        }


        /**
         * Add a symbol folder to the library
         *
         * @param library The folder to add to the library
         */
        public virtual bool add(File library)
        {
            return false;
        }



        public void* find_item(LibraryItem item)
        {
            return m_root.find(
                TraverseType.LEVEL_ORDER,
                TraverseFlags.ALL,
                item
                );
        }


        /**
         * Get a symbol from the library
         *
         * @param name The name of the symbol
         */
        public Symbol @get(string name)

            ensures(result.name == name)

        {
            if (!m_symbols.has_key(name))
            {
                var symbol = new Symbol(name);

                symbol.weak_ref(on_weak_notify);

                m_names[symbol] = name;
                m_symbols[name] = symbol;

                symbol_used(symbol);

                return symbol;
            }

            return m_symbols[name];
        }


        /**
         * Returns index of the child
         *
         * @param child The child to determince the index of
         */
        public int child_position(void* child)

            requires(child != null)

        {
            var temp_child = (Node<LibraryItem>*) child;

            return_val_if_fail(temp_child->parent != null, -1);

            return temp_child->parent.child_position(temp_child);
        }


        /**
         * Returns a description for this node
         *
         * @param node The iterator for the node
         */
        public string get_description(void* node)
        {
            var temp_node = (Node<LibraryItem>*) node;

            var item = temp_node->data;

            return_val_if_fail(item != null, false);

            return item.description ?? "";
        }


        /**
         * Returns an icon for this node
         *
         * @param node The iterator for the node
         */
        public Geda3.ProjectIcon get_icon(void* node)
        {
            var temp_node = (Node<LibraryItem>*) node;

            var item = temp_node->data;

            return_val_if_fail(item != null, false);

            return item.icon;
        }


        /**
         * Returns the item for this node
         *
         * @param node The iterator for the node
         */
        public LibraryItem get_item(void* node)
        {
            var temp = (Node<LibraryItem>*) node ?? m_root;

            return temp->data;
        }


        /**
         * Returns a name for this node
         *
         * @param node The iterator for the node
         */
        public string get_name(void* node)
        {
            var temp_node = (Node<LibraryItem>*) node;

            var item = temp_node->data;

            return_val_if_fail(item != null, false);

            return item.tab;
        }


        /**
         * Returns the parent node
         *
         * @param child The child node
         */
        public void* get_parent(void* child)

            requires(child != null)

        {
            var temp_child = (Node<LibraryItem>*) child;

            return temp_child->parent;

        }


        /**
         * Returns if the node contains a renamable item
         *
         * @param node The node to test for reamability
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
         * Is the given node a leaf node
         *
         * @param node The node to test
         */
        public bool is_leaf(void *node)
        {
            var temp = (Node<LibraryItem>*) node ?? m_root;

            return temp->is_leaf();
        }


        /**
         * Get the number of children of a parent
         *
         * @param parent The iterator for the parent
         */
        public int n_children(void *parent)
        {
            var temp = (Node<LibraryItem>*) parent ?? m_root;

            return (int)temp->n_children();
        }


        public void* next_sibling(void *node)

            requires(node != null)

        {
            var temp_node = (Node<LibraryItem>*) node;

            return temp_node->next_sibling();
        }


        /**
         * Get an indexed child of a parent
         *
         * @param parent The iterator for the parent
         * @param index The index of the child
         */
        public void* nth_child(void* parent, int index)
        {
            var temp = (Node<LibraryItem>*) parent ?? m_root;

            return temp->nth_child(index);
        }


        public void remove_node(void* node)

            requires(node != null)

        {
            var temp_node = (Node<LibraryItem>*) node;

            unowned Node<LibraryItem>? parent = temp_node->parent;
            return_if_fail(parent != null);

            var item = temp_node->data;
            return_if_fail(item != null);

            item.request_insertion.disconnect(on_request_insertion);
            item.request_refresh.disconnect(on_request_refresh);
            item.request_update.disconnect(on_request_update);

            var index = parent.child_position(temp_node);
            return_if_fail(index >= 0);

            temp_node->unlink();

            node_removed(parent, index);            
        }


        /**
         * A dummy project item to use in the root node
         *
         * This dummy item allows the node to use a non-nullable type.
         */
        private static LibraryItem s_dummy = null; //new ProjectFolder();


        /**
         * Lookup table to get the name of finalized objects
         */
        private Gee.HashMap<void*,string> m_names;


        /**
         * The root node in the project tree
         *
         * Children of the root node store the project data. Data
         * inside the root node is ignored.
         */
        private Node<LibraryItem> m_root;


        /**
         * Interned symbols
         */
        private Gee.HashMap<string,weak Symbol> m_symbols;



        /**
         *
         *
         *
         */
        private void on_request_insertion(LibraryItem parent, LibraryItem item)
        {
            unowned Node<LibraryItem>? parent_node = m_root.find(
                TraverseType.LEVEL_ORDER,
                TraverseFlags.ALL,
                parent
                );

            return_if_fail(parent_node != null);

            unowned Node<LibraryItem> item_node = parent_node.append(
                new Node<LibraryItem>(item)
                );

            return_if_fail(item_node != null);

            item.request_insertion.connect(on_request_insertion);
            item.request_refresh.connect(on_request_refresh);
            item.request_update.connect(on_request_update);

            node_inserted(item_node);
        }


        /**
         * 
         *
         *
         */
        private void on_request_refresh(LibraryItem item)
        {
            item.perform_refresh(this);
            
//            unowned Node<LibraryItem>? node = m_root.find(
//                TraverseType.LEVEL_ORDER,
//                TraverseFlags.ALL,
//                item
//                );

//            return_if_fail(node != null);

//            unowned Node<LibraryItem>? parent = node.parent;
//            return_if_fail(parent != null);

//            var index = parent.child_position(node);
//            return_if_fail(index >= 0);

//            node.unlink();

//            item.request_insertion.disconnect(on_request_insertion);
//            item.request_refresh.disconnect(on_request_refresh);
//            item.request_update.disconnect(on_request_update);

//            node_removed(parent, index);            
        }


        /**
         *
         *
         * 
         */
        private void on_request_update(LibraryItem item, void* updater)
        {
            unowned Node<LibraryItem>? node = m_root.find(
                TraverseType.LEVEL_ORDER,
                TraverseFlags.ALL,
                item
                );

            return_if_fail(node != null);

            var items = new Gee.ArrayList<LibraryItem>();

            unowned Node<LibraryItem>? iter = node.first_child();

            while (iter != null)
            {
                items.add(get_item(iter));

                iter = iter.next_sibling();
            }

            var temp_updater = (LibraryItem.Updater) updater;

            temp_updater(items);
        }


        /**
         *
         */
        private void on_weak_notify(Object object)

            requires(m_names.has_key(object))

        {
            var name = m_names[object];

            return_if_fail(m_symbols.has_key(name));

            m_symbols.unset(name);

            symbol_unused(name);
        }
    }
}
