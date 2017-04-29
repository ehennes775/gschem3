namespace Gschem3
{
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/ProjectWidget.ui.xml")]
    public class ProjectWidget : Gtk.Box, Gtk.Buildable
    {
        /**
         * Requests files to be opened in an editor
         *
         * @param files The files to open in an editor
         */
        public signal void open_files(File[] files);


        /**
         * Indicates files can be added to the project
         */
        public bool can_add_files
        {
            get;
            private set;
        }


        /**
         * Indicates files can be opened from the project
         */
        public bool can_open_files
        {
            get;
            private set;

            // The default value establishes the initial value of the
            // "enabled" property on the action.
            default = false;
        }


        /**
         * Indicates files can be removed from the project
         */
        public bool can_remove_files
        {
            get;
            private set;

            // The default value establishes the initial value of the
            // "enabled" property on the action.
            default = false;
        }


        /**
         * Indicates the selected item can be renamed
         */
        public bool can_rename_item
        {
            get;
            private set;

            // The default value establishes the initial value of the
            // "enabled" property on the action.
            default = false;
        }


        /**
         * The project this widget views
         */
        public Geda3.Project? project
        {
            get;
            set;

            // Setting the default to null allows the signal handlers
            // to run and establish values for other properties.
            default = null;
        }


        /**
         * Initialize the class
         */
        static construct
        {
        }


        /**
         * Initialize the instance
         */
        construct
        {
            notify["project"].connect(on_notify_project);

            // Setup context menu

            tree.events |= Gdk.EventMask.BUTTON_PRESS_MASK;
            tree.button_press_event.connect(on_button_release_event);

            // Setup drag and drop

            var targets = new Gtk.TargetList(null);
            targets.add_uri_targets(TargetInfo.URI_LIST);

            Gtk.drag_dest_set(
                this,
                Gtk.DestDefaults.ALL,
                target_entries,
                Gdk.DragAction.MOVE
                );

            Gtk.drag_dest_set_target_list(this, targets);

            drag_data_received.connect(on_data_received);

            // Setup tree model

            m_adapter = new ProjectAdapter();

            m_adapter.refresh.connect(on_adapter_refresh);

            bind_property(
                "project",
                m_adapter,
                "project",
                BindingFlags.SYNC_CREATE
                );

            tree.model = m_adapter;

            // set up tree selection

            selection = tree.get_selection();
            selection.mode = Gtk.SelectionMode.MULTIPLE;
            selection.changed.connect(update_sensitivities);

            // set up signal handling for renaming items

            m_renderer.edited.connect(on_item_edited);
        }


        /**
         * {@inheritDoc}
         */
        public void parser_finished(Gtk.Builder builder)

            ensures(context != null)

        {
            var builder2 = new Gtk.Builder.from_resource(
                "/com/github/ehennes775/gschem3/ProjectWidgetMenu.ui.xml"
                );

            context = builder2.get_object("context") as MenuModel;
        }


        /**
         * Add this widget's actions to the action map
         *
         * @param map The action map to receive this widget's actions
         */
        public void add_actions(ActionMap map)
        {
            map.add_action_entries(action_entries, this);

            bind_property(
                "can-add-files",
                map.lookup_action("project-add-files"),
                "enabled",
                BindingFlags.SYNC_CREATE
                );

            bind_property(
                "can-open-files",
                map.lookup_action("project-open-files"),
                "enabled",
                BindingFlags.SYNC_CREATE
                );

            bind_property(
                "can-remove-files",
                map.lookup_action("project-remove-files"),
                "enabled",
                BindingFlags.SYNC_CREATE
                );

            bind_property(
                "can-rename-item",
                map.lookup_action("project-rename-item"),
                "enabled",
                BindingFlags.SYNC_CREATE
                );
        }


        /**
         * Identifies the drop operation
         */
        private enum TargetInfo
        {
            URI_LIST,
            COUNT
        }


        /**
         * Organized from most frequently used to least frequently used
         */
        private const ActionEntry[] action_entries =
        {
            { "project-open-files", on_open_files, null, null, null },
            { "project-add-files", on_add_files, null, null, null },
            { "project-remove-files", on_remove_files, null, null, null },
            { "project-rename-item", on_rename_item, null, null, null }
        };


        /**
         * The drag and drop targets
         *
         * Currently, an empty list since drag_dest_set cannot accept
         * a null pointer.
         */
        private const Gtk.TargetEntry[] target_entries =
        {
        };


        /**
         * The context menu for the project widget
         */
        private ProjectAdapter m_adapter;


        /**
         * The cell renderer for the name in the tree view
         */
        [GtkChild(name="column-name-renderer-name")]
        private Gtk.CellRendererText m_renderer;


        /**
         * The context menu for the project widget
         */
        private MenuModel context;


        /**
         * The selection from the Gtk.TreeView widget
         */
        private Gtk.TreeSelection selection;


        /**
         * A GtkTreeView widget containing the project
         */
        [GtkChild]
        private Gtk.TreeView tree;


        /**
         * Add files to the project
         *
         * @param files the files to add to the project
         */
        private void add_files(File[] files)

            requires(project != null)

        {
            warn_if_fail(can_add_files);

            foreach (var file in files)
            {
                project.add_file(file);
            }
        }


        /**
         * Remove files from the project
         *
         * @param files the files to remove from the project
         */
        private void remove_files(File[] files)

            requires(project != null)

        {
            foreach (var file in files)
            {
                project.remove_file(file);
            }
        }


        /**
         * Gets the selected files from the project tree view
         */
        private File[] get_selected_files()

            requires(selection != null)

        {
            var files = new Gee.ArrayList<File>();

            selection.selected_foreach(
                (model, path, iter) =>
                {
                    Geda3.ProjectItem? item = null;

                    model.get(
                        iter,
                        ProjectAdapter.Column.ITEM, &item
                        );

                    var file = item as Geda3.ProjectFile;

                    if ((file != null) && (file.file != null))
                    {
                        files.add(file.file);
                    }
                }
                );

            return files.to_array();
        }


        /**
         * Gets the selected items from the project tree
         */
        private Gee.Collection<Geda3.ProjectItem> get_selected_items()

            requires(selection != null)

        {
            var items = new Gee.ArrayList<Geda3.ProjectItem>();

            selection.selected_foreach((model, path, iter) =>
                {
                    Geda3.ProjectItem? item = null;

                    model.get(
                        iter,
                        ProjectAdapter.Column.ITEM, &item
                        );

                    if (item is Geda3.ProjectItem)
                    {
                        items.add(item);
                    }
                    else
                    {
                        warning("ProjectAdapter contans invalid item");
                    }
                }
                );

            return items;
        }


        /**
         * Determines if the item is openable
         *
         * @param item The item to check if it can be opened
         * @return This function returns true when the item is openable
         */
        private bool is_openable(Geda3.ProjectItem item)
        {
            var file_item = item as Geda3.ProjectFile;

            return (
                (file_item != null) &&
                (file_item.file != null) &&
                file_item.can_open
                );
        }


        /**
         * Determines if the item is removable
         *
         * @param item The item to check if it can be removed
         * @return This function returns true when the item is removable
         */
        private bool is_removable(Geda3.ProjectItem item)
        {
            var file_item = item as Geda3.RemovableItem;

            return (
                (file_item != null) &&
                file_item.can_remove
                );
        }


        /**
         * Signal handler for when the tree view needs a complete
         * refresh
         */
        private void on_adapter_refresh()
        {
            tree.model = null;
            tree.model = m_adapter;
        }


        /**
         *
         * @todo This function is not displaying a popup menu.
         */
        private bool on_button_release_event(Gdk.EventButton event)
        {
            if (event.triggers_context_menu())
            {
                stdout.printf("Context menu in...\n");

                var menu = new Gtk.Menu.from_model(context);

                var menuitem = new Gtk.MenuItem.with_label("Testing...");
                menu.append(menuitem);

                menu.realize.connect(() => {stdout.printf("realize\n");});
                menu.unrealize.connect(() => {stdout.printf("unrealize\n");});

                menu.map.connect(() => {stdout.printf("map\n");});
                menu.unmap.connect(() => {stdout.printf("unmap\n");});

                menu.activate_current.connect(() => {stdout.printf("activate_current\n");});

                menu.show_all();

                menu.popup(
                    null,
                    null,
                    null,
                    event.button,
                    event.time
                    );

                stdout.printf("Context menu out...\n");

                return true;
            }

            return false;
        }


        /**
         * An event handler for drag and drop data received
         *
         * @param context the drag context
         * @param x the x coordinate of the drop location
         * @param y the y coordinate of the drop location
         * @param data the selection data
         * @param info the number registered in the target list
         * @param timestamp when the drop operation occured
         */
        private void on_data_received(
            Gdk.DragContext context,
            int x,
            int y,
            Gtk.SelectionData data,
            uint info,
            uint timestamp
            )

            requires (info < TargetInfo.COUNT)

        {
            if (info == TargetInfo.URI_LIST)
            {
                var files = new Gee.ArrayList<File>();
                var uris = data.get_uris();

                foreach (var uri in uris)
                {
                    files.add(File.new_for_uri(uri));
                }

                add_files(files.to_array());
            }
        }


        /**
         * Add existing files to the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_add_files(SimpleAction action, Variant? parameter)
        {
            warn_if_fail(can_add_files);

            var dialog = new Gtk.FileChooserDialog(
                "Add Files to Project",
                get_toplevel() as Gtk.Window,
                Gtk.FileChooserAction.OPEN,
                "_Cancel", Gtk.ResponseType.CANCEL,
                "_Open", Gtk.ResponseType.ACCEPT
                );

            dialog.select_multiple = true;

            var response = dialog.run();

            if (response == Gtk.ResponseType.ACCEPT)
            {
                var files = new Gee.ArrayList<File>();

                dialog.get_files().foreach((file) => { files.add(file); });

                add_files(files.to_array());
            }

            dialog.destroy();
        }


        /**
         * An item has been renamed by the user
         *
         * @param path_string the string representation of the path to
         * the item
         * @param new_name The new name for the item
         */
        private void on_item_edited(string path_string, string new_name)

            requires(m_adapter != null)

        {
            try
            {
                var path = new Gtk.TreePath.from_string(path_string);

                Gtk.TreeIter iter;

                var success = m_adapter.get_iter(out iter, path);
                return_if_fail(success);

                Geda3.ProjectItem? item = null;

                m_adapter.get(
                    iter,
                    ProjectAdapter.Column.ITEM, &item
                    );

                var renamable_item = item as Geda3.RenamableItem;
                return_if_fail(renamable_item != null);

                renamable_item.rename(new_name);
            }
            catch (Error error)
            {
                critical(error.message);
            }
        }


        /**
         * Signal handler for when the project changes
         *
         * @param param unused
         */
        private void on_notify_project(ParamSpec param)
        {
            can_add_files = (project != null);
        }


        /**
         * Open files from the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_open_files(SimpleAction action, Variant? parameter)
        {
            warn_if_fail(can_open_files);

            var files = new Gee.ArrayList<File>();
            var items = get_selected_items();

            foreach (var item in items)
            {
                if (!is_openable(item))
                {
                    continue;
                }

                var file_item = item as Geda3.ProjectFile;

                if (file_item != null)
                {
                    if (file_item.file == null)
                    {
                        warning("null file encountered in project tree");
                        continue;
                    }

                    files.add(file_item.file);
                }

            }

            open_files(files.to_array());
        }


        /**
         * Remove files from the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_remove_files(SimpleAction action, Variant? parameter)

            requires(project != null)

        {
            var items = get_selected_items();

            foreach (var item in items)
            {
                if (is_removable(item))
                {
                    project.remove_item(item);
                }
            }
        }


        /**
         * Rename an item in the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_rename_item(SimpleAction action, Variant? parameter)

            requires(project != null)

        {
        }


        /**
         * Update the senstitivities for the actions in this widget
         */
        private void update_sensitivities()
        {
            var items = get_selected_items();

            can_open_files = Geda3.GeeEx.any_match(
                items,
                is_openable
                );

            can_remove_files = Geda3.GeeEx.any_match(
                items,
                is_removable
                );

            can_rename_item = Geda3.GeeEx.one_match(
                items,
                Geda3.ProjectItem.is_renamable
                );
        }
    }
}
