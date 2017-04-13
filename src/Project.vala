namespace Geda3
{
    /**
     * A base class for projects
     */
    public abstract class Project : Object
    {
        /**
         * Indicates a new node inserted into the project
         *
         * @param node The new node inserted into the project
         */
        public signal void node_inserted(void* node);


        /**
         * The project file
         *
         * Other files in the project use a relative path from the
         * project file. Moving this file to another folder will break
         * those paths.
         */
        public abstract File file
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
        public abstract SchematicList schematic_list
        {
            get;
            protected set;
        }


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

            // for testing
            m_schematics.append(
                new Node<ProjectItem>(
                    new ProjectFile(File.new_for_path("untitled.sch"))
                    )
                );

            m_schematics.append(
                new Node<ProjectItem>(
                    new ProjectFile(File.new_for_path("untitled_1.sch"))
                    )
                );

            m_schematics.append(
                new Node<ProjectItem>(
                    new ProjectFile(File.new_for_path("untitled_2.sch"))
                    )
                );

            m_schematics.append(
                new Node<ProjectItem>(
                    new ProjectFile(File.new_for_path("untitled.sym"))
                    )
                );

            m_schematics.append(
                new Node<ProjectItem>(
                    new ProjectFile(File.new_for_path("untitled_1.sym"))
                    )
                );

            m_schematics.append(
                new Node<ProjectItem>(
                    new ProjectFile(File.new_for_path("untitled_2.sym"))
                    )
                );
        }


        /**
         * Get an indexed child of a parent
         *
         * @param node The iterator for the parent
         * @param index The index of the child
         */
        public void add_file(File file)
        {
            unowned Node<ProjectItem> node = m_schematics.append(
                new Node<ProjectItem>(
                    new ProjectFile(file)
                    )
                );

            node_inserted(node);
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

            return_if_fail(temp_child->parent != null);

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
         * Save this project
         */
        public abstract void save() throws FileError;


        /**
         * A dummy project item to use in the root node
         *
         * This dummy item allows the node to use a non-nullable type.
         */
        private static ProjectItem s_dummy = new ProjectFolder();


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
    }
}
