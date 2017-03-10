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
            var temp_file = file;
            var temp_tag = tag;

            if (temp_file == null)
            {
                var dialog = new Gtk.FileChooserDialog(
                    "Save As...",
                    parent,
                    Gtk.FileChooserAction.SAVE,
                    "_Cancel", Gtk.ResponseType.CANCEL,
                    "_Save", Gtk.ResponseType.ACCEPT
                    );

                dialog.do_overwrite_confirmation = true;
                dialog.set_current_name(tab);

                if (dialog.run() == Gtk.ResponseType.ACCEPT)
                {
                    temp_file = dialog.get_file();
                    temp_tag = null;
                }

                dialog.destroy();
            }

            if (temp_file != null)
            {
                var stream = new DataOutputStream(temp_file.replace(
                    temp_tag,
                    true,
                    FileCreateFlags.NONE
                    ));
                
                schematic.write(stream);
                stream.close();

                var file_info = temp_file.query_info(
                    @"$(FileAttribute.STANDARD_DISPLAY_NAME),$(FileAttribute.ETAG_VALUE)",
                    FileQueryInfoFlags.NONE
                    );

                changed = false;
                modified = false;
                file = temp_file;
                tab = file_info.get_display_name();
                tag = file_info.get_etag();
            }
        }


        /**
         * {@inheritDoc}
         */
        public void save_as(Gtk.Window? parent)

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
                var temp_file = dialog.get_file();

                if (temp_file != null)
                {
                    var stream = new DataOutputStream(temp_file.replace(
                        null,
                        true,
                        FileCreateFlags.NONE
                        ));
                    
                    schematic.write(stream);
                    stream.close();

                    var file_info = temp_file.query_info(
                        @"$(FileAttribute.STANDARD_DISPLAY_NAME),$(FileAttribute.ETAG_VALUE)",
                        FileQueryInfoFlags.NONE
                        );

                    changed = false;
                    modified = false;
                    file = temp_file;
                    tab = file_info.get_display_name();
                    tag = file_info.get_etag();
                }
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
    }
}
