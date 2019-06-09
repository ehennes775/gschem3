namespace Geda3
{
    /**
     * A base class for projects
     *
     * {{uml/ProjectUml.svg}}
     */
    public class Project : Object,
        LibraryContributor,
        NetlisterConfiguraion,
        PartlisterConfiguraion
    {
        /**
         * Indicates a node changed in the project
         *
         * @param node The new node inserted into the project
         */
        public signal void node_changed(void* node);


        /**
         * Indicates a new node inserted into the project
         *
         * @param node The new node inserted into the project
         */
        public signal void node_inserted(void* node);


        /**
         * Indicates a node has been removed from the project
         *
         * @param parent The parent of the removed node
         * @param index The location of the node before removal
         */
        public signal void node_removed(void* parent, int index);


        /**
         * Indicates the project has changed since last saved
         */
        public bool changed
        {
            get;
            protected set;
        }


        /**
         * {@inheritDoc}
         */
        public string contributor_name
        {
            get
            {
                return tab;
            }
        }


        /**
         * The project file
         *
         * Other files in the project use a relative path from the
         * project file. Moving this file to another folder will break
         * those paths.
         */
        public File file
        {
            get;
            protected set;
        }


        public File folder
        {
            get
            {
                return m_storage.folder;
            }
        }


        /**
         * A list of the schematics in this project
         *
         * This property is used as a port. To make this property
         * usable as a port, the reference does not change throughout
         * the lifetime of this project object.
         */
        //public abstract SchematicList schematic_list
        //{
        //    get;
        //    protected set;
        //}


        /**
         * A short name for this project
         */
        public string tab
        {
            get;
            protected set;
            default = "Unset";
        }


        /**
         * Initialize the instance
         */
        construct
        {
            m_root = new Node<ProjectItem>(s_dummy);

            var adapter = new Geda3.ProjectItemAdapter(this);

            adapter.item_changed.connect(on_item_changed);

            m_project = m_root.append(
                new Node<ProjectItem>(
                    adapter
                    )
                );

            m_schematics = m_project.append(
                new Node<ProjectItem>(
                    new ProjectFolder(ProjectIcon.BLUE_FOLDER, "sch")
                    )
                );

            notify["file"].connect(on_notify_project_file);
        }


        /**
         * Create a new project
         *
         * @param storage The persistence layer to use for storage
         */
        public Project(ProjectStorage storage)
        {
            m_storage = storage;

            m_storage.bind_property(
                "changed",
                this,
                "changed",
                BindingFlags.SYNC_CREATE
                );

            m_storage.bind_property(
                "file",
                this,
                "file",
                BindingFlags.SYNC_CREATE
                );

            m_storage.item_removed.connect(on_item_removed);

            reload_files();
        }


        /**
         * Add a file to the project
         *
         * This function will not add duplicates
         *
         * @param file The file to add to the project
         */
        public void add_file(File file)

            requires(m_schematics != null)
            requires(m_storage != null)

        {
            var item = find_by_file(file);

            if (item == null)
            {
                var new_item = m_storage.insert_file(file);

                return_if_fail(new_item != null);

                unowned Node<ProjectItem> new_node = m_schematics.append(
                    new Node<ProjectItem>(new_item)
                    );

                node_inserted(new_node);
            }
        }


        /**
         * Returns index of the child
         *
         * @param child The child to determince the index of
         */
        public int child_position(void* child)

            requires(child != null)

        {
            var temp_child = (Node<ProjectItem>*) child;

            return_val_if_fail(temp_child->parent != null, -1);

            return temp_child->parent.child_position(temp_child);
        }


        /**
         * Temporary for development
         */
        public ProjectFile[] get_files()
        {
            return m_storage.get_files();
        }


        /**
         * Returns the item for this node
         *
         * @param node The iterator for the node
         */
        public ProjectItem get_item(void* node)
        {
            var temp = (Node<ProjectItem>*) node ?? m_root;

            return temp->data;
        }


        /**
         * Returns the parent node
         *
         * @param child The child node
         */
        public void* get_parent(void* child)

            requires(child != null)

        {
            var temp_child = (Node<ProjectItem>*) child;

            return temp_child->parent;
        }


        /**
         * Is the given node a leaf node
         *
         * @param node The node to test
         */
        public bool is_leaf(void *node)
        {
            var temp = (Node<ProjectItem>*) node ?? m_root;

            return temp->is_leaf();
        }


        /**
         * {@inheritDoc}
         */
        public Gee.Collection<LibraryEntry> load_library_entries()

            requires(m_storage != null)

        {
            return m_storage.load_library_entries();
        }


        /**
         * Get the number of children of a parent
         *
         * @param parent The iterator for the parent
         */
        public int n_children(void *parent)
        {
            var temp = (Node<ProjectItem>*) parent ?? m_root;

            return (int)temp->n_children();
        }


        /**
         * Get an indexed child of a parent
         *
         * @param parent The iterator for the parent
         * @param index The index of the child
         */
        public void* nth_child(void* parent, int index)
        {
            var temp = (Node<ProjectItem>*) parent ?? m_root;

            return temp->nth_child(index);
        }


        /**
         * Remove a file from the project
         *
         * @param file The file to remove from the project
         */
        public void remove_file(File file)
        {
            var item = find_by_file(file);

            var removable_item = item as Geda3.RemovableItem;

            if ((removable_item != null) && (removable_item.can_remove))
            {
                removable_item.remove();
            }
        }


        /**
         * {@inheritDoc}
         */
        public void retrieve_netlist_export_format(
            ref string format
            )

            requires(m_storage != null)

        {
            m_storage.retrieve_netlist_export_format(ref format);
        }


        /**
         * {@inheritDoc}
         */
        public void retrieve_partlist_export_format(
            ref string format
            )

            requires(m_storage != null)

        {
            m_storage.retrieve_partlist_export_format(ref format);
        }


        /**
         * Save this project
         */
        public void save() throws Error

            requires(m_storage != null)

        {
            m_storage.save();
        }


        /**
         * {@inheritDoc}
         */
        public void store_netlist_export_format(
            string format
            )

            requires(m_storage != null)

        {
            m_storage.store_netlist_export_format(format);
        }


        /**
         * {@inheritDoc}
         */
        public void store_partlist_export_format(
            string format
            )

            requires(m_storage != null)

        {
            m_storage.store_partlist_export_format(format);
        }


        /**
         * A dummy project item to use in the root node
         *
         * This dummy item allows the node to use a non-nullable type.
         */
        private static ProjectItem s_dummy = new ProjectFolder();


        /**
         * The persistence layer for this project
         */
        private ProjectStorage m_storage;


        /**
         * The project node in the project tree
         */
        private unowned Node<ProjectItem> m_project;


        /**
         * The root node in the project tree
         *
         * Children of the root node store the project data. Data
         * inside the root node is ignored.
         */
        private Node<ProjectItem> m_root;


        /**
         * The schematics folder in the project tree
         */
        private unowned Node<ProjectItem> m_schematics;


        /**
         * Find a file in the project tree
         *
         * @return The ProjectFile containing the given file
         */
        private ProjectFile find_by_file(File file)

            requires(m_schematics != null)

        {
            var file_info = file.query_info(
                FileAttribute.ID_FILE,
                FileQueryInfoFlags.NONE
                );

            var file_id = file_info.get_attribute_string(
                FileAttribute.ID_FILE
                );

            return_val_if_fail(file_id != null, null);

            unowned Node<ProjectItem>? iter = m_schematics.first_child();

            while (iter != null)
            {
                var item = iter.data as ProjectFile;

                if ((item != null) && (item.file_id == file_id))
                {
                    return item;
                }

                iter = iter.next;
            }

            return null;
        }


        /**
         * Reload the files in the project tree
         */
        private void reload_files()

            requires(m_schematics != null)

        {
            unowned Node<ProjectItem>? child = m_schematics.first_child();

            while (child != null)
            {
                remove_node(child);

                child = m_schematics.first_child();
            }

            foreach (var item in m_storage.get_files())
            {
                m_schematics.append(
                    new Node<ProjectItem>(item)
                    );
            }
        }


        private void on_item_changed(ProjectItem item)

            requires(item != null)

        {
            unowned Node<ProjectItem>? node = m_root.find(
                TraverseType.LEVEL_ORDER,
                TraverseFlags.ALL,
                item
                );

            if (node != null)
            {
                node_changed(node);
            }
        }


        /**
         * Removes an item from the project
         *
         * @param item The item to remove from the project
         */
        private void on_item_removed(ProjectItem item)
        {
            unowned Node<ProjectItem>? node = m_root.find(
                TraverseType.LEVEL_ORDER,
                TraverseFlags.ALL,
                item
                );

            if (node != null)
            {
                remove_node(node);
            }
        }


        /**
         * Signal handler when the project file changes
         *
         * Three propery notifications are connected to this signal
         * handler. When the project property of this object changes,
         * or the file property of the project object, this handler
         * keeps the tab up to date.
         * 
         * @param param unused
         */
        private void on_notify_project_file(ParamSpec param)
        {
            try
            {
                var file_info = file.query_info(
                    FileAttribute.STANDARD_DISPLAY_NAME,
                    FileQueryInfoFlags.NONE
                    );

                tab = "%s%s".printf(
                    file_info.get_display_name(),
                    changed ? "*" : ""
                    );
            }
            catch (Error error)
            {
                tab = "Error";
            }
        }


        /**
         * Remove a node from the project
         *
         * @param file The node to remove from the project
         */
        private void remove_node(Node<ProjectItem> node)

            requires(node.parent != null)

        {
            unowned Node<ProjectItem>? parent = node.parent;

            var index = parent.child_position(node);
            return_if_fail(index >= 0);

            node.unlink();

            node_removed(parent, index);
        }
    }
}
