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
            schematic = new Geda3.Schematic();
            tag = null;
        }


        /**
         * Create a schematic window with an untitled schematic
         */
        public SchematicWindow()
        {
            tab = "untitled_%d.sch".printf(untitled_number++);
        }


        /**
         * Create a schematic window and load the given schematic file
         */
        public SchematicWindow.with_file(File file) throws Error
        {
            this.file = file;

            var file_info = file.query_info(
                @"$(FileAttribute.STANDARD_DISPLAY_NAME),$(FileAttribute.ETAG_VALUE)",
                FileQueryInfoFlags.NONE
                );

            changed = false;
            modified = false;
            tab = file_info.get_display_name();
            tag = file_info.get_etag();
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
         * {@inheritDoc}
         */
        public void save(Gtk.Window? parent) throws Error

            requires(schematic != null)

        {
            if (file == null)
            {
                save_as(parent);
            }
            else
            {
                write(file, tag);

                // TODO: catch and handle IOError.WRONG_ETAG
            }
        }


        /**
         * {@inheritDoc}
         */
        public void save_as(Gtk.Window? parent) throws Error

            requires(schematic != null)

        {
            var dialog = new Gtk.FileChooserDialog(
                "Save As...",
                parent,
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
                write(dialog.get_file(), null);
            }

            dialog.destroy();
        }


        /**
         *
         */
        private Geda3.Schematic schematic;


        /**
         *
         */
        private string tag;


        /**
         * A number used in the untitled filename to make it unique
         */
        private static int untitled_number = 1;


        /**
         * Write the schematic to a file
         *
         * When writing to a new file or overwriting an existing file,
         * the next_file represents the new or existing file to
         * overwrite. And, the current tag should be null.
         *
         * When saving to an existing file, the next_file represents
         * the current file and the current_tag should be set to the
         * current tag. Setting the current tag ensures the contents of
         * the existing file are not overwritten if modified elsewhere
         * since the last save.
         * 
         * @param next_file the current or next file to save to
         * @param current_tag the current tag or null
         */
        private void write(File next_file, string? current_tag)
        {
            var stream = new DataOutputStream(next_file.replace(
                current_tag,
                true,
                FileCreateFlags.NONE
                ));
            
            schematic.write(stream);
            stream.close();

            var file_info = next_file.query_info(
                @"$(FileAttribute.STANDARD_DISPLAY_NAME),$(FileAttribute.ETAG_VALUE)",
                FileQueryInfoFlags.NONE
                );

            changed = false;
            modified = false;
            file = next_file;
            tab = file_info.get_display_name();
            tag = file_info.get_etag();
        }
    }
}
