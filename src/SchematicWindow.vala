namespace Gschem3
{
    /**
     * A document window for editing a gschem schematic
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/SchematicWindow.ui.xml")]
    public class SchematicWindow : DocumentWindow,
        Fileable,
        Reloadable,
        Savable
    {
        /**
         * The filename extension for schematic files
         */
        public const string SCHEMATIC_EXTENSION = ".sch";


        /**
         * The filename extension for symbol files
         */
        public const string SYMBOL_EXTENSION = ".sym";


        /**
         * {@inheritDoc}
         */
        public bool can_reload
        {
            get;
            protected set;
        }


        /**
         * {@inheritDoc}
         */
        public bool changed
        {
            get;
            protected set;
        }


        /**
         * The underlying file for the schematic
         *
         * If this value is null, an underlying file has not been
         * created yet.
         */
        public File? file
        {
            get;
            protected set;
        }


        /**
         *  A unique string identifing the file
         */
        public string? file_id
        {
            get;
            protected set;
        }


        /**
         *  Indicates the file has been modified
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
            file_id = null;
            monitor = null;
            schematic = new Geda3.Schematic();
            tag = null;

            drawing.draw.connect(on_draw);
        }


        /**
         * Create a schematic window with an untitled schematic
         */
        public SchematicWindow()
        {
            tab = "untitled_%d%s".printf(
                ++untitled_number,
                SCHEMATIC_EXTENSION
                );
        }


        /**
         * Create a schematic window and load the given schematic file
         */
        public SchematicWindow.with_file(File file) throws Error
        {
            read(file);
        }


        /**
         * {@inheritDoc}
         */
        public void reload(Gtk.Window? parent) throws Error

            requires(file != null)

        {
            read(file);
        }


        /**
         * {@inheritDoc}
         */
        public void save(Gtk.Window? parent) throws Error
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
        {
            var dialog = new Gtk.FileChooserDialog(
                "Save As...",
                parent,
                Gtk.FileChooserAction.SAVE,
                "_Cancel", Gtk.ResponseType.CANCEL,
                "_Save", Gtk.ResponseType.ACCEPT
                );

            dialog.do_overwrite_confirmation = true;

            foreach (var filter in save_filters)
            {
                dialog.add_filter(filter);
            }

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
         * Zoom the schematic to fit the view
         */
        public void zoom_extents()

            requires(drawing != null)
            requires(painter != null)
            requires(schematic != null)

        {
            matrix = Cairo.Matrix.identity();

            var bounds = schematic.calculate_bounds(painter);

            var width = drawing.get_allocated_width();
            var height = drawing.get_allocated_height();

            matrix.translate(
                Math.round(width / 2.0),
                Math.round(height / 2.0)
                );

            var scale = double.min(
                0.9 * width / (bounds.max_x - bounds.min_x).abs(),
                0.9 * height / (bounds.max_y - bounds.min_y).abs()
                );

            matrix.scale(scale, -scale);

            matrix.translate(
                (bounds.max_x + bounds.min_x) / -2.0,
                (bounds.max_y + bounds.min_y) / -2.0
                );

            drawing.queue_draw();
        }


        /**
         * The drawing area for the schematic
         */
        [GtkChild]
        private Gtk.DrawingArea drawing;


        /**
         * Matrix for converting drawing to window coordinates
         */
        private Cairo.Matrix matrix = Cairo.Matrix.identity();


        /**
         * This montior checks for changes to the underlying file
         */
        private FileMonitor? monitor;


        /**
         * The painter used to draw schematics
         */
        private Geda3.SchematicPainterCairo painter = new Geda3.SchematicPainterCairo();


        /**
         * File filters used by the save dialog
         */
        private static Gtk.FileFilter[] save_filters = create_filters();


        /**
         * The schematic this window is editing
         */
        private Geda3.Schematic schematic;


        /**
         * The settigs for this schematic window
         */
        private SchematicWindowSettings m_settings = SchematicWindowSettings.get_default();


        /**
         * This tag determines if changes have been made to the
         * underlying file by an external process.
         */
        private string? tag;


        /**
         * A number used in the untitled filename to make it unique
         */
        private static int untitled_number = 0;


        /**
         * Create the file filters used by the save dialog
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
            schematics.add_pattern(@"*$SCHEMATIC_EXTENSION");
            filters.add(schematics);

            var symbols = new Gtk.FileFilter();
            symbols.set_filter_name("Symbols");
            symbols.add_pattern(@"*$SYMBOL_EXTENSION");
            filters.add(symbols);

            return filters.to_array();
        }


        /**
         * Event handler for changes occuring to the underlying file
         */
        private void on_changed(File file_a, File? file_b, FileMonitorEvent event)
        {
            stdout.printf("on_changed event=%s\n", event.to_string());
        }


        /**
         * Draw the schematic window contents
         */
        private bool on_draw(Cairo.Context context)

            requires(painter != null)
            requires(m_settings != null)
            requires(schematic != null)

        {
            var background = m_settings.scheme[0];

            context.set_source_rgba(
                background.red,
                background.green,
                background.blue,
                background.alpha
                );

            context.rectangle(
                0,
                0,
                drawing.get_allocated_width(),
                drawing.get_allocated_height()
                );

            context.fill();

            context.transform(matrix);

            m_settings.grid.draw(context, m_settings.scheme);

            painter.cairo_context = context;
            painter.color_scheme = m_settings.scheme;
            schematic.draw(painter);

            return true;
        }


        /**
         * Read the schematic from a file
         *
         * @param next_file the file to read the schematic from
         */
        private void read(File next_file) throws Error

            requires(schematic != null)

        {
            if (monitor != null)
            {
                monitor.cancel();
            }

            var stream = new DataInputStream(next_file.read());
            schematic.read(stream);
            stream.close();

            var file_info = next_file.query_info(
                @"$(FileAttribute.STANDARD_DISPLAY_NAME),$(FileAttribute.ETAG_VALUE),$(FileAttribute.ID_FILE)",
                FileQueryInfoFlags.NONE
                );

            // TODO: this file monitor is receiving spurious events
            // from the output stream handling the backup file.

            monitor = next_file.monitor_file(FileMonitorFlags.NONE);
            monitor.changed.connect(on_changed);

            changed = false;
            modified = false;
            file = next_file;
            file_id = file_info.get_attribute_string(FileAttribute.ID_FILE);
            tab = file_info.get_display_name();
            tag = file_info.get_etag();
        }


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
        private void write(File next_file, string? current_tag) throws Error

            requires(schematic != null)

        {
            if (monitor != null)
            {
                monitor.cancel();
            }

            var stream = new DataOutputStream(next_file.replace(
                current_tag,
                true,
                FileCreateFlags.NONE
                ));

            schematic.write(stream);
            stream.close();

            var file_info = next_file.query_info(
                @"$(FileAttribute.STANDARD_DISPLAY_NAME),$(FileAttribute.ETAG_VALUE),$(FileAttribute.ID_FILE)",
                FileQueryInfoFlags.NONE
                );

            // TODO: this file monitor is receiving spurious events
            // from the output stream handling the backup file.

            monitor = next_file.monitor_file(FileMonitorFlags.NONE);
            monitor.changed.connect(on_changed);

            changed = false;
            modified = false;
            file = next_file;
            file_id = file_info.get_attribute_string(FileAttribute.ID_FILE);
            tab = file_info.get_display_name();
            tag = file_info.get_etag();
        }
    }
}
