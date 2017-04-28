namespace Geda3
{
    /**
     * A base class for projects
     *
     * {{uml/ProjectUml.svg}}
     */
    public class Project : Object
    {
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
         * Initialize the instance
         */
        construct
        {
            m_root = new Node<ProjectItem>(s_dummy);

            m_project = m_root.append(
                new Node<ProjectItem>(
                    new Geda3.ProjectItemAdapter(this)
                    )
                );

            m_schematics = m_project.append(
                new Node<ProjectItem>(
                    new ProjectFolder(ProjectIcon.BLUE_FOLDER, "sch")
                    )
                );
        }


        public Project(ProjectStorage storage)
        {
            m_storage = storage;

            m_storage.bind_property(
                "file",
                this,
                "file",
                BindingFlags.SYNC_CREATE
                );

            foreach (var item in m_storage.get_files())
            {
                m_schematics.append(
                    new Node<ProjectItem>(item)
                    );
            }
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
            unowned Node<ProjectItem>? node = find_by_file(file);

            if (node == null)
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
         * Get the number of children of a parent
         *
         * @param node The iterator for the parent
         */
        public int n_children(void *parent)
        {
            var temp = (Node<ProjectItem>*) parent ?? m_root;

            return (int)temp->n_children();
        }


        /**
         * Get an indexed child of a parent
         *
         * @param node The iterator for the parent
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
            unowned Node<ProjectItem>? node = find_by_file(file);

            if (node != null)
            {
                remove_node(node);
            }
        }


        /**
         * Remove an item from the project
         *
         * @param item The item to remove from the project
         */
        public void remove_item(ProjectItem item)
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
         * Remove a node from the project
         *
         * @param file The node to remove from the project
         */
        public void remove_node(void* node)

            requires(node != null)

        {
            var temp = (Node<ProjectItem>*) node;
            unowned Node<ProjectItem>? parent = temp->parent;

            return_if_fail(parent != null);

            var index = parent.child_position(temp);

            var item = temp->data as RemovableItem;

            if ((item != null) && item.can_remove)
            {
                item.remove(m_storage);

                temp->unlink();

                node_removed(parent, index);
            }
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
         * A dummy project item to use in the root node
         *
         * This dummy item allows the node to use a non-nullable type.
         */
        private static ProjectItem s_dummy = new ProjectFolder();


        /**
         *
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
         * @return This function returns the node containing the item
         * that represents the given file. If not found, this function
         * returns null.
         */
        private unowned Node<ProjectItem>? find_by_file(File file)

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
                    return iter;
                }

                iter = iter.next;
            }

            return null;
        }
    }
}
