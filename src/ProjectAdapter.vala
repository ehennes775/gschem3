namespace Gschem3
{
    /**
     * Adapts a project to a tree model
     */
    public class ProjectAdapter : Object, Gtk.TreeModel
    {
        /**
         * Indicates the entire tree should be refreshed
         */
        public signal void refresh();


        /**
         * An enumeration of the columns in the tree model
         */
        public enum Column
        {
            /**
             * A Gdk.PixBuf used as an icon for the Geda3.ProjectItem
             */
            ICON,

            /**
             * A short name for the Geda3.ProjectItem
             */
            NAME,

            /**
             * The Geda3.ProjectItem
             */
            ITEM,

            /**
             * The number of columns in this tree model
             */
            COUNT
        }


        /**
         * The project adapted to the tree model
         */
        public Geda3.Project? project
        {
            get
            {
                return m_project;
            }
            set
            {
                if (m_project != null)
                {
                    m_project.node_inserted.disconnect(on_node_inserted);
                }

                m_project = value;
                m_stamp = (int)Random.next_int();

                if (m_project != null)
                {
                    m_project.node_inserted.connect(on_node_inserted);
                }
            }

            // Set to null to trigger signal handlers
            default = null;
        }


        /**
         * Initialize the class
         */
        static construct
        {
            s_icons = new Gdk.Pixbuf[Geda3.ProjectIcon.COUNT];
            
            s_icons[Geda3.ProjectIcon.BLANK] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/Blank.svg"
                );

            s_icons[Geda3.ProjectIcon.BLUE_FOLDER] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/BlueFolder.svg"
                );

            s_icons[Geda3.ProjectIcon.MISSING] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/Missing.svg"
                );

            s_icons[Geda3.ProjectIcon.ORANGE_FOLDER] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/OrangeFolder.svg"
                );

            s_icons[Geda3.ProjectIcon.SCHEMATIC] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/Schematic.svg"
                );

            s_icons[Geda3.ProjectIcon.SYMBOL] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/Symbol.svg"
                );
        }


        /**
         * Initialize the instance
         */
        construct
        {
            notify["project"].connect(on_notify_project);
        }


        /**
         * Returns the GLib.Type used in a column
         *
         * @param column The zero based column index
         * @return The GLib.Type used in the column. If the column
         * index is out of range, this function returns
         * GLib.Type.INVALID.
         */
        public Type get_column_type(int column)
        {
            switch (column)
            {
                case Column.ICON:
                    return typeof(Gdk.Pixbuf);

                case Column.NAME:
                    return typeof(string);

                case Column.ITEM:
                    return typeof(Geda3.ProjectItem);

                default:
                    return_val_if_reached(Type.INVALID);
            }
        }


        /**
         * Returns the TreeModelFlags for this tree model
         *
         * @return The TreeModelFlags
         */
        public Gtk.TreeModelFlags get_flags()
        {
            return 0;
        }


        /**
         * Convert a tree path to an iterator
         *
         * ||''return''||''description''                     ||
         * ||true      ||A valid iterator for the input path ||
         * ||false     ||Path does not reference a valid node||
         * ||false     ||Logic error                         ||
         *
         * @param iter The iterator corresponding to the tree path
         * @param path The path to convert to an iterator
         * @return True when iter represents a valid iterator
         */
        public bool get_iter(out Gtk.TreeIter iter, Gtk.TreePath path)

            ensures(result || iter.stamp != m_stamp)
            ensures(!result || iter.stamp == m_stamp)

        {
            Gtk.TreeIter? parent = null;

            foreach (var index in path.get_indices())
            {
                var success = iter_nth_child(out iter, parent, index);

                if (!success)
                {
                    return invalid_iter(out iter);
                }

                parent = iter;
            }

            return true;
        }


        /**
         * Returns the number of columns in the tree
         * 
         * @return The number of columns in the tree
         */
        public int get_n_columns()
        {
            return Column.COUNT;
        }


        /**
         * Converts a tree iterator into a tree path
         *
         * @param iter The tree iterator
         * @return The tree path
         */
        public Gtk.TreePath? get_path(Gtk.TreeIter iter)

            requires(iter_valid(iter))
            requires(m_project != null)

        {
            stdout.printf("get_path()\n");
            stdout.printf("    stamp = %d\n", iter.stamp);
            stdout.printf("    user_data = %p\n", iter.user_data);

            var node = iter.user_data;
            var parent = m_project.get_parent(node);
            var path = new Gtk.TreePath();

            while (parent != null)
            {
                var index = m_project.child_position(node);

                path.prepend_index(index);

                node = parent;
                parent = m_project.get_parent(node);
            }


            return path;
        }


        /**
         * Gets the value in a column
         * 
         * @param iter The tree iterator of the row
         * @param column The zero based column index
         * @param contents The contents of the cell
         */
        public void get_value(Gtk.TreeIter iter, int column, out Value contents)

            requires(iter_valid(iter))
            requires(m_project != null)
            requires(s_icons != null)

        {
            var item = m_project.get_item(iter.user_data);

            return_if_fail(item != null);

            switch (column)
            {
                case Column.ICON:
                    contents = s_icons[item.icon];
                    break;

                case Column.NAME:
                    contents = item.tab;
                    break;

                case Column.ITEM:
                    contents = item;
                    break;

                default:
                    return_if_reached();
            }
        }


        /**
         * Get an iterator to the first child of a parent
         *
         * ||''return''||''first''||''parent''||''description''             ||
         * ||true      ||valid    ||null      ||First iterator of the root  ||
         * ||true      ||valid    ||valid     ||First iterator of the parent||
         * ||false     ||invalid  ||null      ||Root has no children        ||
         * ||false     ||invalid  ||valid     ||Parent has no children      ||
         * ||false     ||invalid  ||invalid   ||Logic error                 ||
         *
         * @param first An iterator to the first child of the parent or
         * invalid if the parent has no children. This invalid iterator
         * is indicated by the return value.
         * @param parent An iterator to the parent or null if the root
         * @return True when first represents a valid iterator
         */
        public bool iter_children(out Gtk.TreeIter first, Gtk.TreeIter? parent)

            ensures(result || first.stamp != m_stamp)
            ensures(!result || first.stamp == m_stamp)

        {
            return iter_nth_child(out first, parent, 0);
        }


        /**
         * Determines if the tree node has child nodes
         * 
         * @param parent The parent node
         * @return true if the parent node has children
         */
        public bool iter_has_child(Gtk.TreeIter parent)

            requires(iter_valid(parent))

        {
            return !m_project.is_leaf(parent.user_data);
        }


        /**
         * Get the number of child nodes
         * 
         * @param parent The parent node
         * @return The number of child nodes
         */
        public int iter_n_children(Gtk.TreeIter? parent)

            requires((parent == null) || (parent.stamp == m_stamp))
            ensures(result >= 0)

        {
            var retval = 0;
            
            stdout.printf("iter_n_children()\n");

            if (parent == null)
            {
                stdout.printf("    root\n");

                retval = m_project.n_children(null);
            }
            else
            {
                stdout.printf("    node %p\n", parent.user_data);

                var node = (Node<string>*) parent.user_data;

                stdout.printf("    node %s\n", (string)node->data);

                retval = m_project.n_children(node);
            }

            stdout.printf("    count = %d\n", retval);

            return retval;
        }


        /**
         * Get the next iterator at the same level
         *
         * ||''return''||''iter out''||''iter in''||''description''            ||
         * ||true      ||valid       ||valid      ||An iterator to next node   ||
         * ||false     ||invalid     ||valid      ||No nodes after the iterator||
         * ||false     ||invalid     ||invalid    ||Logic error                ||
         *
         * @param iter The current position
         * @return True when iter represents a valid iterator
         */
        public bool iter_next(ref Gtk.TreeIter iter)

            ensures(result || iter.stamp != m_stamp)
            ensures(!result || iter.stamp == m_stamp)

        {
            // precondition checks are inside the function so the
            // output iterator can be invalidated

            if (iter.stamp != m_stamp)
            {
                invalid_iter(out iter);
                return_val_if_reached(false);
            }

            var node = (Node<string>*) iter.user_data;

            void* next = node->next_sibling();

            return make_iter(out iter, next);
        }


        /**
         * Get an iterator to the indexed child of a parent
         *
         * ||''return''||''first''||''parent''||''index''||''description''             ||
         * ||true      ||valid    ||null      ||valid    ||First iterator of the root  ||
         * ||true      ||valid    ||valid     ||valid    ||First iterator of the parent||
         * ||false     ||invalid  ||null      ||valid    ||Root has no children        ||
         * ||false     ||invalid  ||valid     ||valid    ||Parent has no children      ||
         * ||false     ||invalid  ||invalid   ||         ||Logic error                 ||
         * ||false     ||invalid  ||          ||invalid  ||Logic error                 ||
         *
         * @param first An iterator to the indexed child of the parent
         * or invalid if the parent has no children. This invalid
         * iterator is indicated by the return value.
         * @param parent An iterator to the parent or null if the root
         * @return True when first represents a valid iterator
         */
        public bool iter_nth_child(out Gtk.TreeIter child, Gtk.TreeIter? parent, int index)

            ensures(result || child.stamp != m_stamp)
            ensures(!result || child.stamp == m_stamp)

        {
            // precondition checks are inside the function so the
            // output iterator can be invalidated

            if (index < 0)
            {
                critical("invalid index = %d", index);
                invalid_iter(out child);
                return_val_if_reached(false);
            }

            if ((parent != null) && (parent.stamp != m_stamp))
            {
                critical("invalid iter");
                invalid_iter(out child);
                return_val_if_reached(false);
            }

            if (m_project == null)
            {
                return invalid_iter(out child);
            }

            void* child_node = null;

            if (parent == null)
            {
                child_node = m_project.nth_child(null, index);
            }
            else
            {
                var node = (Node<string>*) parent.user_data;
                
                child_node = m_project.nth_child(node, index);
            }

            return make_iter(out child, child_node);
        }


        /**
         * Get the parent node of a child
         *
         * ||''return''||''parent''||''child''||''description''         ||
         * ||true      ||valid     ||valid    ||Returns parent node     ||
         * ||false     ||invalid   ||valid    ||Child has no parent node||
         * ||false     ||invalid   ||invalid  ||Logic error             ||
         *
         * @param parent An iterator for the parent node. If the child
         * does not have a parent, or a logic error occurs, the parent
         * iterator is set to invalid.
         * @param child The child iterator to obtain the parent iterator
         * for.
         * @return True when parent represents a valid iterator
         */
        public bool iter_parent(out Gtk.TreeIter parent, Gtk.TreeIter child)

            ensures(result || parent.stamp != m_stamp)
            ensures(!result || parent.stamp == m_stamp)

        {
            // precondition checks are inside the function so the
            // output iterator can be invalidated

            if (child.stamp != m_stamp)
            {
                critical("invalid stamp");
                invalid_iter(out parent);
                return_val_if_reached(false);
            }

            if (m_project == null)
            {
                return invalid_iter(out parent);
            }

            void *node = child.user_data;

            if (node == null)
            {
                invalid_iter(out parent);
                return_val_if_reached(false);
            }

            return make_iter(out parent, ((Node<string>*)node)->parent);
        }


        /**
         * Icons to use in rows
         *
         * The index uses the Geda3.ProjectIcon enumeration
         */
        private static Gdk.Pixbuf[] s_icons;


        /**
         *
         */
        private Geda3.Project? m_project;


        /**
         * A random number assigned to this instance to validate
         * iterators
         */
        private int m_stamp;


        /**
         * Invalidate an iterator
         *
         * @param iter The iterator to make invalid
         * @return false
         */
        private bool invalid_iter(out Gtk.TreeIter iter)
        {
            iter = Gtk.TreeIter()
            {
                stamp = ~m_stamp,
                user_data = null,
                user_data2 = null,
                user_data3 = null
            };

            return false;
        }


        /**
         * Check an iterator for validity
         *
         * @param iter The iterator to check for validity
         * @return true if the iterator is valid
         */
        private bool iter_valid(Gtk.TreeIter iter)
        {
            return (iter.stamp == m_stamp) && (iter.user_data != null);
        }


        /**
         * Signal handler for when the project property changes
         */
        private void on_notify_project(ParamSpec param)
        {
            refresh();
        }


        /**
         * Make a valid iterator referencing the given node
         *
         * @param iter The iterator to make invalid
         * @return false
         */
        private bool make_iter(out Gtk.TreeIter iter, void *node)
        {
            var valid = (node != null);

            iter = Gtk.TreeIter()
            {
                stamp = valid ? m_stamp : ~m_stamp,
                user_data = node,
                user_data2 = null,
                user_data3 = null
            };

            return valid;
        }


        /**
         * Signal handler when a node is added to the project
         *
         * @param node The node added to the project
         */
        private void on_node_inserted(void* node)
        {
            var iter = Gtk.TreeIter();
            var success = make_iter(out iter, node);

            return_if_fail(success);

            var path = get_path(iter);

            row_inserted(path, iter);
        }
    }
}
