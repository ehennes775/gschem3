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

            // The default value establishes the initial value of the
            // "enabled" property on the action.
            default = true;    // temporarily true for testing
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
         * Initialize the instance
         */
        construct
        {
            // Setup actions

            var group = new SimpleActionGroup();
            group.add_action_entries(action_entries, this);
            insert_action_group("prj", group);

            bind_property(
                "can-add-files",
                group.lookup_action("add-files"),
                "enabled",
                BindingFlags.SYNC_CREATE
                );

            bind_property(
                "can-open-files",
                group.lookup_action("open-files"),
                "enabled",
                BindingFlags.SYNC_CREATE
                );

            bind_property(
                "can-remove-files",
                group.lookup_action("remove-files"),
                "enabled",
                BindingFlags.SYNC_CREATE
                );

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

            model = new Gtk.ListStore(
                2,
                typeof(string),
                typeof(File)
                );

            tree.model = model;

            var cell = new Gtk.CellRendererText();

            tree.insert_column_with_attributes(
                -1,
                "File",
                cell,
                "text",
                0
                );

            selection = tree.get_selection();
            selection.mode = Gtk.SelectionMode.MULTIPLE;
            selection.changed.connect(update_sensitivities);
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
            { "open-files", on_open_files, null, null, null },
            { "add-files", on_add_files, null, null, null },
            { "remove-files", on_remove_files, null, null, null }
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
        private MenuModel context;


        /**
         * A GtkTreeModel for testing
         */
        private Gtk.ListStore model;


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
        {
            foreach (var file in files)
            {
                Gtk.TreeIter iter;

                model.append(out iter);

                model.set(
                    iter,
                    0, file.get_basename(),
                    1, file
                    );
            }
        }


        /**
         * Remove files from the project
         *
         * @param files the files to remove from the project
         */
        private void remove_files(File[] files)
        {
            foreach (var file in files)
            {
                stdout.printf("remove: %s\n", file.get_path());
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
                    File file = null;

                    model.get(
                        iter,
                        1, &file
                        );

                    if (file != null)
                    {
                        files.add(file);
                    }
                }
                );

            return files.to_array();
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
         * Open files from the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_open_files(SimpleAction action, Variant? parameter)
        {
            warn_if_fail(can_open_files);

            var files = get_selected_files();

            open_files(files);
        }


        /**
         * Remove files from the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_remove_files(SimpleAction action, Variant? parameter)
        {
            warn_if_fail(can_remove_files);

            var files = get_selected_files();

            remove_files(files);
        }


        /**
         * Update the senstitivities for the actions in this widget
         */
        private void update_sensitivities()

            requires(selection != null)

        {
            var count = selection.count_selected_rows();
            var enabled = (count > 0);

            can_open_files = enabled;
            can_remove_files = enabled;
        }
    }
}
