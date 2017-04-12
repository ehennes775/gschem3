namespace Gschem3
{
    /**
     * Adapts the project to a tree view
     */
    public class ProjectAdapter : Object, Gtk.TreeModel
    {
        /**
         * Get the type of a column
         *
         * @param column The column index
         * @return The type of the column
         */
        public Geda3.Project? project
        {
            get
            {
                return m_project;
            }
            set
            {
                stdout.printf("assigning project to %p\n", value);

                m_project = value;
                m_stamp = (int)Random.next_int();
            }
            default = null;
        }


        /**
         * Initialize the class
         */
        static construct
        {
            m_icons = new Gdk.Pixbuf[Geda3.ProjectIcon.COUNT];
            
            m_icons[Geda3.ProjectIcon.BLANK] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/BlueFolder.svg"
                );

            m_icons[Geda3.ProjectIcon.BLUE_FOLDER] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/BlueFolder.svg"
                );

            m_icons[Geda3.ProjectIcon.MISSING] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/Missing.svg"
                );

            m_icons[Geda3.ProjectIcon.ORANGE_FOLDER] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/OrangeFolder.svg"
                );

            m_icons[Geda3.ProjectIcon.SCHEMATIC] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/Schematic.svg"
                );

            m_icons[Geda3.ProjectIcon.SYMBOL] = new Gdk.Pixbuf.from_resource(
                "/com/github/ehennes775/gschem3/Symbol.svg"
                );
        }


        construct
        {
        }

        /**
         * Get the type of a column
         *
         * @param column The column index
         * @return The type of the column
         */
        public Type get_column_type(int column)
        {
            switch (column)
            {
                case Column.ICON:
                    return typeof(Gdk.Pixbuf);

                case Column.NAME:
                    return typeof(string);

                case Column.FILE:
                    return typeof(File);

                default:
                    return_val_if_reached(Type.INVALID);
            }
        }


        /**
         * Get the TreeModelFlags for this tree model
         *
         * @return The TreeModelFlags
         */
        public Gtk.TreeModelFlags get_flags()
        {
            stdout.printf("get_flags()\n");

            return 0;
        }


        /**
         * Convert a tree path to an iterator
         *
         * ||''return''||''first''||''description''                     ||
         * ||true      ||valid    ||A valid iterator for the input path ||
         * ||false     ||invalid  ||Path does not reference a valid node||
         * ||false     ||invalid  ||Logic error                         ||
         *
         * @param iter The iterator corresponding to the tree path
         * @param path The path to convert to an iterator
         * @return True when iter represents a valid iterator
         */
        public bool get_iter(out Gtk.TreeIter iter, Gtk.TreePath path)

            ensures(result || iter.stamp != m_stamp)
            ensures(!result || iter.stamp == m_stamp)

        {
            stdout.printf("get_iter(\"%s\")\n", path.to_string());

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
         * Get the number of columns in the tree
         * 
         * @return The number of columns in the tree
         */
        public int get_n_columns()
        {
            stdout.printf("get_n_columns()\n");

            return Column.COUNT;
        }



        public Gtk.TreePath? get_path(Gtk.TreeIter iter)
        {
            stdout.printf("get_path()\n");
            stdout.printf("    stamp = %d\n", iter.stamp);
            stdout.printf("    user_data = %p\n", iter.user_data);

            var path = new Gtk.TreePath();

            path.prepend_index(0);

            return path;
        }


        public void get_value(Gtk.TreeIter iter, int column, out Value contents)
        {
            stdout.printf("get_value()\n");

            switch (column)
            {
                case Column.ICON:
                    contents = m_icons[m_project.get_icon(iter.user_data)];
                    break;

                case Column.NAME:
                    contents = m_project.tab(iter.user_data);
                    break;

                case Column.FILE:
                    contents = File.new_for_path(".");
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
            stdout.printf("iter_children()\n");

            // precondition checks are inside the function so the
            // output iterator can be invalidated

            return iter_nth_child(out first, parent, 0);
        }


        /**
         *
         * @param
         * @return
         */
        public bool iter_has_child(Gtk.TreeIter parent)

            requires(parent.stamp == m_stamp)

        {
            stdout.printf("iter_has_child()\n");

            return !m_project.is_leaf(parent.user_data);
        }


        /**
         *
         * @param
         * @return
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
            stdout.printf("iter_next()\n");

            // precondition checks are inside the function so the
            // output iterator can be invalidated

            if (iter.stamp != m_stamp)
            {
                invalid_iter(out iter);
                return_val_if_reached(false);
            }

            var node = (Node<string>*) iter.user_data;

            void* next = node->next_sibling();

            stdout.printf("    next=%p\n", next);

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
            stdout.printf("iter_nth_child(,, %d)\n", index);

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
            stdout.printf("iter_parent()\n");

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
         *
         */
        private enum Column
        {
            ICON,
            NAME,
            FILE,
            COUNT
        }


        /**
         * The context menu for the project widget
         */
        private static Gdk.Pixbuf[] m_icons;


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


        private bool iter_valid(Gtk.TreeIter iter)
        {
            return false;
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
    }
}
