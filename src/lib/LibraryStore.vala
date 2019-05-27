namespace Geda3
{
    /**
     *
     */
    public class LibraryStore : Object,
        ComplexLibrary,
        SymbolLibrary
    {
        /**
         * The object contributing symbols at the project level
         */
        public LibraryContributor? project_contributor
        {
            get
            {
                if (b_project_contributor != null)
                {
                    return b_project_contributor.contributor;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                set_contributor(
                    ref b_project_contributor,
                    value,
                    ProjectIcon.ORANGE_FOLDER
                    );
            }
        }


        /**
         * The object contributing symbols at the system level
         */
        public LibraryContributor? system_contributor
        {
            get
            {
                if (b_system_contributor != null)
                {
                    return b_system_contributor.contributor;
                }
                else
                {
                    return null;
                }
            }
            set
            {
                set_contributor(
                    ref b_system_contributor,
                    value,
                    ProjectIcon.PLUM_FOLDER
                    );
            }
        }

        public signal void bif();


        /**
         * Initialize the instance
         */
        construct
        {
            project_contributor = new LibraryContributorTest();
            system_contributor = new SystemLibrary();

            m_paths = new Gee.ArrayList<string>();

            m_paths.add(
                "/home/ehennes/Projects/edalib/symbols"
                );


            var schematic = new Schematic();

            var file = File.new_for_path("/home/ehennes/Projects/edalib/symbols/ech-crystal-4.sym");
            schematic.read_from_file(file);

            m_symbol = new ComplexSymbol(schematic);
        }


        private static int s_times = 0;

        /**
         * The library is a singleton for development
         *
         * Needs to be 1:1 with the main window in the future
         *
         * This singleton method is really incompatible with the
         * gobject system. This function can be reentered during
         * type initializaion.
         */
        public static LibraryStore get_instance()
        {
            stdout.printf("Entering LibraryStore.get_instance()\n");
            s_times++;

            if (s_times > 1)
            {
                critical("Reentered LibraryStore.get_instance()");
            }

            if (s_instance == null)
            {
                s_instance = new LibraryStore();
            }

            stdout.printf("Exiting LibraryStore.get_instance()\n");
            s_times--;

            return s_instance;
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



        public void* find_item(LibraryItem item)
        {
            return m_root.find(
                TraverseType.LEVEL_ORDER,
                TraverseFlags.ALL,
                item
                );
        }

        public void remove_node(void* node)

            requires(node != null)

        {
            var temp_node = (Node<LibraryItem>*) node;

            unowned Node<LibraryItem>? parent = temp_node->parent;
            return_if_fail(parent != null);

            var item = temp_node->data;
            return_if_fail(item != null);

            item.item_changed.disconnect(on_item_changed);
            //item.request_insertion.disconnect(on_request_insertion);
            //item.request_refresh.disconnect(on_request_refresh);

            var index = parent.child_position(temp_node);
            return_if_fail(index >= 0);

            temp_node->unlink();

            node_removed(parent, index);
        }


        /**
         * A dummy library item to use in the root node
         *
         * This dummy item allows the node to use a non-nullable type.
         */
        // TODO: create a dummy library item
        private static LibraryItem s_dummy = null;


        /**
         * The library is a singleton for development
         *
         * Needs to be 1:1 with the main window in the future
         */
        private static LibraryStore s_instance; // = null;


        /**
         * The backing store for the project symbol contributor
         */
        private ContributorAdapter? b_project_contributor = null;


        /**
         * The backing store for the system symbol contributor
         */
        private ContributorAdapter? b_system_contributor = null;


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
         * Add a contributor to the library
         *
         * @param contributor The contributor to add to the library
         */
        private void add_contributor(ContributorAdapter contributor)

            requires(m_root != null)

        {
            unowned Node<LibraryItem> item_node = m_root.append(
                new Node<LibraryItem>(contributor)
                );

            node_inserted(item_node);

            //contributor.perform_refresh(this);

            var entries = contributor.contributor.load_library_entries();

            foreach (var entry in entries)
            {
                var item = new LibraryFolder.with_entry(entry);
                
                item_node.append(
                    new Node<LibraryItem>(item)
                    );

                item.item_changed.connect(on_item_changed);
                item.request_insertion.connect(on_request_insertion);

                item.perform_refresh(this);
            }
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

            item.item_changed.connect(on_item_changed);
            item.request_insertion.connect(on_request_insertion);
            //item.request_refresh.connect(on_request_refresh);

            node_inserted(item_node);
        }


        /**
         * Remove a contributor from the library
         *
         * @param contributor The contributor to remove
         */
        private void remove_contributor(ContributorAdapter contributor)

            requires(m_root != null)

        {
            unowned Node<LibraryItem>? item_node = m_root.find_child(
                TraverseFlags.ALL,
                contributor
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


        /**
         * Set the contributor backing store
         *
         * (Removes common code for between properties of the same
         * type.)
         *
         * TODO: keep the two contributors in an order, so hinting
         * for s symbol path occurs in deterministic order.
         *
         * @param adapter The backing store for the contributor adapter
         * @param contributor The underlying contributor
         */
        private void set_contributor(
            ref ContributorAdapter? adapter,
            LibraryContributor? contributor,
            ProjectIcon icon
            )
        {
            if (adapter != null)
            {
                remove_contributor(adapter);
            }

            adapter = null;

            if (contributor != null)
            {
                adapter = new ContributorAdapter(
                    contributor,
                    icon
                    );
            }

            if (adapter != null)
            {
                add_contributor(adapter);
            }
        }


        public ComplexSymbol @get(string name)
        {
            foreach (var path_string in m_paths)
            {
                var path = Path.build_filename(
                    path_string,
                    name
                    );

                var file = File.new_for_path(path);

                if (file.query_exists())
                {
                    var schematic = new Schematic();
                    schematic.read_from_file(file);

                    // Currently, a shortcut:
                    // change all the detached attributes from the
                    // detached color to the attached color.

                    foreach (var item in schematic.items)
                    {
                        var attribute = item as AttributeChild;

                        if (attribute == null)
                        {
                            continue;
                        }

                        if (attribute.name == null)
                        {
                            continue;
                        }

                        if (attribute.visibility != Visibility.VISIBLE)
                        {
                            continue;
                        }

                        attribute.color = Color.ATTRIBUTE;
                    }

                    return new ComplexSymbol(schematic);
                }
            }
            
            return m_symbol;
        }


        private Gee.List<string> m_paths;


        private ComplexSymbol m_symbol;

    }
}
