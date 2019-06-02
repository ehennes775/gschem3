namespace Gschem3
{
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/prjw/ProjectWidget.ui.xml")]
    public class ProjectWidget : Gtk.Bin,
        ActionProvider,
        Gtk.Buildable
    {
        /**
         * For opening files in the application
         */
        public DocumentOpener opener
        {
            get;
            set;
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

            // connect actions

            m_add_files_action.activate.connect(
                on_add_files
                );

            m_add_new_file_action.activate.connect(
                on_add_new_file
                );

            m_open_files_action.activate.connect(
                on_open_files
                );

            m_remove_files_action.activate.connect(
                on_remove_files
                );

            m_rename_item_action.activate.connect(
                on_rename_item
                );
        }


        /**
         * {@inheritDoc}
         */
        public void add_actions_to(ActionMap map)
        {
            map.add_action(m_add_files_action);
            map.add_action(m_add_new_file_action);
            map.add_action(m_open_files_action);
            map.add_action(m_remove_files_action);
            map.add_action(m_rename_item_action);
        }


        /**
         * {@inheritDoc}
         */
        public void parser_finished(Gtk.Builder builder)

            ensures(m_context_menu != null)

        {
            var builder2 = new Gtk.Builder.from_resource(
                "/com/github/ehennes775/gschem3/gui/prjw/ProjectWidgetMenu.ui.xml"
                );

            m_context_menu = builder2.get_object("context") as MenuModel;
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
         *
         */
        private SimpleAction m_add_new_file_action = new SimpleAction(
            "project-add-new-file",
            null
            );


        /**
         *
         */
        private SimpleAction m_open_files_action = new SimpleAction(
            "project-open-files",
            null
            );

        /**
         *
         */
        private SimpleAction m_add_files_action = new SimpleAction(
            "project-add-files",
            null
            );

        /**
         *
         */
        private SimpleAction m_remove_files_action = new SimpleAction(
            "project-remove-files",
            null
            );

        /**
         *
         */
        private SimpleAction m_rename_item_action = new SimpleAction(
            "project-rename-item",
            null
            );

        /**
         * The file filters used by the add files dialog
         */
        private static Gtk.FileFilter[] s_add_filters = create_filters();


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
         *
         */
        private ProjectAdapter m_adapter;


        /**
         * The column containing the short name (tab)
         *
         * This value is required for the rename operation in function
         * {@link on_rename_item()}.
         */
        [GtkChild(name="column-name")]
        private Gtk.TreeViewColumn m_column;


        /**
         * A dialog for adding files to the project
         */
        private Gtk.FileChooserDialog m_add_files_dialog = null;


        /**
         * The cell renderer containing the short name (tab)
         *
         * This value is required for the rename operation in function
         * {@link on_rename_item()}.
         */
        [GtkChild(name="column-name-renderer-name")]
        private Gtk.CellRendererText m_renderer;


        /**
         * The context menu for the project widget
         */
        private MenuModel m_context_menu;


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
            //warn_if_fail(can_add_files);

            foreach (var file in files)
            {
                project.add_file(file);
            }
        }


        /**
         * Create the file filters used by the add files dialog
         */
        private static Gtk.FileFilter[] create_filters()
        {
            var filters = new Gee.ArrayList<Gtk.FileFilter>();

            var all = new Gtk.FileFilter();
            all.set_filter_name("All Files");
            all.add_pattern("*.*");
            filters.add(all);

            var schematics = new Gtk.FileFilter();
            schematics.set_filter_name("Schematics");
            schematics.add_pattern(@"*$(SchematicWindow.SCHEMATIC_EXTENSION)");
            filters.add(schematics);

            return filters.to_array();
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
         *
         */
        private bool on_button_release_event(Gdk.EventButton event)
        {
            if (event.triggers_context_menu())
            {
                var menu = new Gtk.Menu.from_model(m_context_menu);

                menu.attach_to_widget(tree, null);

                // Depricated GTK+ 3.22
                menu.popup(
                    null,
                    null,
                    null,
                    event.button,
                    event.time
                    );

                //menu.popup_at_pointer(null);

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
            //warn_if_fail(can_add_files);

            if (m_add_files_dialog == null)
            {
                m_add_files_dialog = new Gtk.FileChooserDialog(
                    "Add Files to Project",
                    get_toplevel() as Gtk.Window,
                    Gtk.FileChooserAction.OPEN,
                    "_Cancel", Gtk.ResponseType.CANCEL,
                    "_Open", Gtk.ResponseType.ACCEPT
                    );

                foreach (var filter in s_add_filters)
                {
                    m_add_files_dialog.add_filter(filter);
                }

                m_add_files_dialog.select_multiple = true;
            }

            var response = m_add_files_dialog.run();

            if (response == Gtk.ResponseType.ACCEPT)
            {
                var files = new Gee.ArrayList<File>();

                m_add_files_dialog.get_files().foreach((file) => { files.add(file); });

                add_files(files.to_array());
            }

            m_add_files_dialog.hide();
        }


        /**
         * Add a new file to the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_add_new_file(
            SimpleAction action,
            Variant? parameter
            )

            requires(opener != null)
            requires(project != null)

        {
            var dialog = new Gtk.FileChooserDialog(
                "Add New Schematic",
                get_toplevel() as Gtk.Window,
                Gtk.FileChooserAction.SAVE,
                "_Cancel", Gtk.ResponseType.CANCEL,
                "_OK",     Gtk.ResponseType.OK,
                null
                );

            dialog.set_current_folder(
                project.file.get_parent().get_path()
                );

            var status = dialog.run();
            dialog.hide();

            if (status == Gtk.ResponseType.OK)
            {
                var files = new File[]
                {
                    File.new_for_path(dialog.get_filename())
                };

                opener.open_with_files(files);

                add_files(files);
            }
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
            var enabled = project != null;

            m_add_files_action.set_enabled(enabled);
            m_add_new_file_action.set_enabled(enabled);
        }


        /**
         * Open files from the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_open_files(SimpleAction action, Variant? parameter)
        {
            //warn_if_fail(can_open_files);

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

            opener.open_with_files(files.to_array());
        }


        /**
         * Remove files from the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_remove_files(SimpleAction action, Variant? parameter)
        {
            //warn_if_fail(can_remove_files);

            var items = get_selected_items();

            foreach (var item in items)
            {
                var removable_item = item as Geda3.RemovableItem;

                if ((removable_item != null) && (removable_item.can_remove))
                {
                    removable_item.remove();
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

            requires(m_column != null)
            requires(m_renderer != null)
            requires(tree != null)

        {
            //warn_if_fail(can_rename_item);

            var paths = selection.get_selected_rows(null);
            return_if_fail(paths != null);
            return_if_fail(paths.length() == 1);

            unowned List<Gtk.TreePath> first = paths.first();
            return_if_fail(first != null);

            var path = first.data;
            return_if_fail(path != null);

            // Documentation shows calling grab_focus() after
            // set_cursor_on_cell(), but it actually works calling it
            // before.
            tree.grab_focus();

            tree.set_cursor_on_cell(
                path,
                m_column,
                m_renderer,
                true           // start_editing
                );
        }


        /**
         * Update the senstitivities for the actions in this widget
         */
        private void update_sensitivities()
        {
            var items = get_selected_items();

            m_open_files_action.set_enabled(Geda3.GeeEx.any_match(
                items,
                is_openable
                ));

            m_remove_files_action.set_enabled(Geda3.GeeEx.any_match(
                items,
                is_removable
                ));

            m_rename_item_action.set_enabled(Geda3.GeeEx.one_match(
                items,
                Geda3.ProjectItem.is_renamable
                ));
        }
    }
}
