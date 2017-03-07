namespace Gschem3
{
    /**
     * A document window for editing a gschem schematic
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/SchematicWindow.ui.xml")]
    public class SchematicWindow : DocumentWindow,
        Reloadable,
        Savable
    {
        /**
         * Indicates the document can be reloaded
         */
        public bool can_reload
        {
            get;
            protected set;
        }


        /**
         * Indicates the document has changed since last saved
         */
        public bool changed
        {
            get;
            protected set;
        }


        /**
         * The underlying file for the schematic
         *
         * If this value is null, an underlying file has not beed created yet.
         */
        public File file
        {
            get;
            private set;
        }


        /**
         * Indicates the file has changed since last loaded
         */
        public bool modified
        {
            get;
            protected set;
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
            file = null;
            tag = null;

            this.notify["file"].connect(on_notify_file);
        }


        /**
         * Create a schematic window with an untitled schematic
         */
        public SchematicWindow()
        {
        }


        /**
         * Create a schematic window and load the given schematic file
         */
        public SchematicWindow.with_file(File file) throws Error
        {
            this.file = file;
        }


        /**
         * Reload the document
         */
        public void reload()

            requires(file != null)

        {
            changed = false;
            modified = false;
        }


        /**
         * Save the document
         */
        public void save() throws Error
        {
            var temp_file = file;

            if (temp_file == null)
            {
                var dialog = new Gtk.FileChooserDialog(
                    "Save As...",
                    null,
                    Gtk.FileChooserAction.SAVE,
                    "_Cancel", Gtk.ResponseType.CANCEL,
                    "_Save", Gtk.ResponseType.ACCEPT
                    );

                dialog.do_overwrite_confirmation = true;
                dialog.set_current_name(tab);

                if (dialog.run() == Gtk.ResponseType.ACCEPT)
                {
                    temp_file = dialog.get_file();
                }

                dialog.destroy();
            }

            if (temp_file != null)
            {
                changed = false;
                file = temp_file;
            }
        }


        /**
         * Save the document using another filename
         */
        public void save_as()
        {
            var dialog = new Gtk.FileChooserDialog(
                "Save As...",
                null,
                Gtk.FileChooserAction.SAVE,
                "_Cancel", Gtk.ResponseType.CANCEL,
                "_Save", Gtk.ResponseType.ACCEPT
                );

            dialog.do_overwrite_confirmation = true;

            if (file == null)
            {
                dialog.set_current_name(tab);
            }
            else
            {
                dialog.set_file(file);
            }

            if (dialog.run() == Gtk.ResponseType.ACCEPT)
            {
                var temp_file = dialog.get_file();

                if (temp_file != null)
                {
                    changed = false;
                    file = temp_file;
                }
            }

            dialog.destroy();
        }


        /**
         *
         */
        private string tag;


        /**
         * A number used in the untitled filename to make it unique
         */
        private static int untitled_number = 1;


        /**
         *
         */
        private void on_notify_file()
        {
            if (file == null)
            {
                tab = "untitled_%d.sch".printf(untitled_number++);
            }
            else
            {
                var file_info = file.query_info(
                    @"$(FileAttribute.STANDARD_DISPLAY_NAME),$(FileAttribute.ETAG_VALUE)",
                    FileQueryInfoFlags.NONE
                    );

                tab = file_info.get_display_name();
            }
        }
    }
}
