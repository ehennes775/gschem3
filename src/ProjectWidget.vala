namespace Gschem3
{
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/ProjectWidget.ui.xml")]
    public class ProjectWidget : Gtk.Box, Gtk.Buildable
    {
        /**
         * Initialize the instance
         */
        construct
        {
            // Setup actions

            var group = new SimpleActionGroup();
            group.add_action_entries(action_entries, this);
            insert_action_group("prj", group);

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
                stdout.printf("%s\n", file.get_path());
            }
        }


        /**
         *
         * @todo This function is not displaying a popup menu.
         */
        public bool on_button_release_event(Gdk.EventButton event)
        {
            if (event.triggers_context_menu())
            {
                stdout.printf("Context menu...\n");

                var menu = new Gtk.Menu.from_model(context);

                menu.show_all();

                menu.popup(
                    null,
                    null,
                    null,
                    event.button,
                    event.time
                    );

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

            dialog.close();
        }


        /**
         * Remove files from the project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_remove_files(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_remove_files()\n");
        }
    }
}
