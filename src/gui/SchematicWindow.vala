namespace Gschem3
{
    /**
     * A document window for editing a gschem schematic
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/SchematicWindow.ui.xml")]
    public class SchematicWindow : DocumentWindow,
        Fileable,
        Geda3.Invalidatable,
        Reloadable,
        Savable,
        Zoomable
    {
        /**
         * A signal indicating the color scheme has changed
         *
         * This signal provides a parameter for the sinks, so that they
         * don't need to maintain a reference to the color scheme, and
         * can simply perform an update when the signal is received.
         *
         * @param scheme The new color scheme
         */
        public signal void color_scheme_changed(
            Geda3.ColorScheme scheme
            );


        /**
         * A signal indicating items in the selection have changed
         *
         *
         */
        public signal void draw_tool(Geda3.SchematicPainter painter);


        /**
         * A signal indicating items in the selection have changed
         *
         *
         */
        public signal void selection_changed();


        /**
         *
         */
        public signal bool tool_button_press_event(Gdk.EventButton event);


        /**
         *
         */
        public signal bool tool_button_release_event(Gdk.EventButton event);


        /**
         *
         */
        public signal bool tool_key_press_event(Gdk.EventKey event);


        /**
         *
         */
        public signal bool tool_key_release_event(Gdk.EventKey event);


        /**
         *
         */
        public signal bool tool_motion_notify_event(Gdk.EventMotion event);


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
         *
         */
        public Gee.Collection<Geda3.SchematicItem>? selection
        {
            owned get
            {
                return m_selected;
            }
        }

        /**
         * The settings for use by this schematic window
         *
         * Setting this property to null will assign the default
         * settings. The default settings are shared across all
         * schematic windows.
         */
        public SchematicWindowSettings settings
        {
            get
            {
                return b_settings;
            }
            set
            {
                if (b_settings != null)
                {
                    b_settings.notify.disconnect(on_notify_settings);

                    b_settings.color_scheme_changed.disconnect(
                        on_color_scheme_changed
                        );
                }

                b_settings = value ?? SchematicWindowSettings.get_default();

                return_if_fail(b_settings != null);

                b_settings.notify.connect(on_notify_settings);

                b_settings.color_scheme_changed.connect(
                    on_color_scheme_changed
                    );
            }
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
            file = null;
            file_id = null;
            monitor = null;
            schematic = new Geda3.Schematic();
            tag = null;

            m_selected = new Gee.HashSet<Geda3.SchematicItem>();


            schematic.invalidate.connect(on_invalidate_item);

            drawing.add_events(
                Gdk.EventMask.BUTTON_PRESS_MASK |
                Gdk.EventMask.BUTTON_RELEASE_MASK |
                Gdk.EventMask.KEY_PRESS_MASK |
                Gdk.EventMask.KEY_RELEASE_MASK |
                Gdk.EventMask.POINTER_MOTION_MASK
                );

            drawing.button_press_event.connect(on_button_press_event);
            drawing.button_release_event.connect(on_button_release_event);
            drawing.draw.connect(on_draw);
            //drawing.key_press_event.connect(on_key_press_event);
            //drawing.key_release_event.connect(on_key_release_event);
            drawing.motion_notify_event.connect(on_motion_notify_event);

            //drawing.can_focus = true;
            drawing.sensitive = true;
        }


        /**
         * Create a schematic window with an untitled schematic
         */
        public SchematicWindow(ComplexFactory factory)
        {
            tab = @"untitled_$(++untitled_number)$(SCHEMATIC_EXTENSION)";
        }


        /**
         * Find the closest item the the given coordinates
         *
         * The x and y coordinates are user coordinates.
         * The distance is in device coordinates.
         *
         * @param x The x coordinate of the point
         * @param y The y coordinate of the point
         * @param distance The maximum distance for items
         * @return The closest item or null if none
         */
        public Geda3.SchematicItem? closest_item(
            int x,
            int y,
            double distance
            )
        {
            // need to setup painter

            var dx = distance;
            var dy = distance;

            device_to_user_distance(ref dx, ref dy);

            dx = Math.fabs(dx);

            return schematic.closest_item(painter, x, y, dx);
        }


        /**
         * Create a schematic window and load the given schematic file
         *
         * With this function as a constructor, an error would generate
         * assertion for freeing a floating object.
         *
         * @param file The schematic file to load
         * @return The schematic window
         */
        public static SchematicWindow create(File file, ComplexFactory factory) throws Error
        {
            var window = new SchematicWindow(factory);
            
            window.read(file);

            return window;
        }


        /**
         * Add an item to the schematic
         *
         * In the future, this will be the function that supports redo
         * undo.
         *
         * @param item The item to add to the schematic
         */
        public void add_item(Geda3.SchematicItem item)

            requires(schematic != null)

        {
            schematic.add(item);
        }


        /**
         * Convert device coordinates to user coordinates
         */
        public void device_to_user(ref double x, ref double y)
        {
            var inverse = matrix;
            var status = inverse.invert();

            return_if_fail(status == Cairo.Status.SUCCESS);

            inverse.transform_point(ref x, ref y);
        }


        /**
         * Convert device displacement to user displacement
         */
        public void device_to_user_distance(
            ref double dx,
            ref double dy
            )
        {
            var inverse = matrix;
            var status = inverse.invert();

            return_if_fail(status == Cairo.Status.SUCCESS);

            inverse.transform_distance(ref dx, ref dy);
        }


        /**
         * Invalidate an area of the window in user coordinates
         *
         * @param bounds The area to invalidate in user coordinates
         */
        public void invalidate_bounds(Geda3.Bounds bounds)
        {
            var x0 = (double) bounds.min_x;
            var y0 = (double) bounds.min_y;
            var x1 = (double) bounds.max_x;
            var y1 = (double) bounds.max_y;

            matrix.transform_point(ref x0, ref y0);
            matrix.transform_point(ref x1, ref y1);

            invalidate_device(x0, y0, x1, y1);
        }


        /**
         *
         * @param x0 The x coordinate of the first corner in ? coordinates
         * @param y0 The y coordinate of the first corner in ? coordinates
         * @param x1 The x coordinate of the second corner in ? coordinates
         * @param y1 The y coordinate of the second corner in ? coordinates
         */
        public void invalidate_device(double x0, double y0, double x1, double y1)
        {
            var bounds = Geda3.Bounds.with_fpoints(x0, y0, x1, y1);

            // convert to widget coordinates

            if (get_has_window())
            {
                // untested case, so punt and invalidate the entire area

                queue_draw();

                return_if_reached();
            }
            else
            {
                Gtk.Allocation allocation;

                get_allocation(out allocation);

                bounds.translate(allocation.x, allocation.y);
            }

            queue_draw_area(
                bounds.min_x,
                bounds.min_y,
                bounds.get_width(),
                bounds.get_height()
                );
        }


        /**
         * Invalidate an item in the window
         *
         * @param item The item to invalidate
         */
        public void invalidate_item(Geda3.SchematicItem item, bool reveal)
        {
            var bounds = item.calculate_bounds(painter, reveal);

            invalidate_user(bounds);
        }

        // this function needs to be reconcied with the above.
        public void on_invalidate_item(Geda3.SchematicItem item)
        {
            var bounds = item.calculate_bounds(painter, true);

            invalidate_user(bounds);
        }


        /**
         * Invalidate an area of the window in user coordinates
         *
         * @param bounds The area to invalidate in user coordinates
         */
        public void invalidate_user(Geda3.Bounds bounds)
        {
            var x0 = (double) bounds.min_x;
            var y0 = (double) bounds.min_y;
            var x1 = (double) bounds.max_x;
            var y1 = (double) bounds.max_y;

            matrix.transform_point(ref x0, ref y0);
            matrix.transform_point(ref x1, ref y1);

            invalidate_device(x0, y0, x1, y1);
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
         * Pan a point to the center of the window
         *
         * @param x The x displacement in steps
         * @param y The y displacement in steps
         */
        public void pan_delta(int dx, int dy)
        {
            pan_displacement(
                50 * dx,
                50 * dy
                );
        }


        /**
         * Pan a point to the center of the window
         *
         * @param x The x coordinate in device units
         * @param y The y coordinate in device units
         */
        public void pan_point(int x, int y)

            requires(x >= 0)
            requires(y >= 0)

        {
            var width = drawing.get_allocated_width();
            var height = drawing.get_allocated_height();

            return_if_fail(x < width);
            return_if_fail(y < height);

            var dx = (width / 2) - x;
            var dy = (height / 2) - y;

            pan_displacement(dx, dy);
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


        public void scale_grid_down()
        {
        }


        public void scale_grid_up()
        {
        }

        public void select_all()
        {
            m_selected.clear();
            m_selected.add_all(schematic.items);

            queue_draw();
            selection_changed();
        }


        /**
         *
         *
         */
        public void select_box(Geda3.Bounds box)

            requires(schematic != null)
            requires(m_selected != null)

        {
            var items = schematic.intersected_items(
                painter,
                box
                );

            m_selected.clear();

            m_selected.add_all(items);

            queue_draw();
            selection_changed();
        }


        /**
         * Select a drawing grid for this window
         *
         * @param name The name of the grid to select
         */
        public void select_grid(string name)

            requires(b_settings != null)

        {
            b_settings.set_grid_by_name(name);
        }


        /**
         * Places a single item in the selection
         *
         * Passing in null clears the selection.
         *
         * @param item The item to be selected item
         * @param toggle Indicates to toggle the state of the item
         */
        public void select_item(
            Geda3.SchematicItem? item,
            bool toggle
            )

            requires(m_selected != null)

        {
            if (toggle)
            {
                if (item != null)
                {
                    if (m_selected.contains(item))
                    {
                        stdout.printf("Item out\n");
                        m_selected.remove(item);
                    }
                    else
                    {
                        stdout.printf("Item in\n");
                        m_selected.add(item);
                    }

                    queue_draw();
                    selection_changed();
                }
            }
            else
            {
                m_selected.clear();

                if (item != null)
                {
                        stdout.printf("Item select\n");
                    m_selected.add(item);
                }

                queue_draw();
                selection_changed();
            }
        }


        public void clear_selection()
        {
            m_selected.clear();

            queue_draw();
            selection_changed();
        }


        /**
         * Snap an angle using the current snap mode
         *
         * @param angle The angle, in degrees
         * @return The snapped angle, in degrees
         */
        public int snap_angle(int angle)
        {
            return Geda3.Coord.snap(angle, 15);
        }


        /**
         * Snap a point to the grid of this window
         *
         * The coordinates must be user coordinates.
         *
         * @param x The x coordinate to snap
         * @param y The y coordinate to snap
         */
        public void snap_point(ref int x, ref int y)
        {
            x = Geda3.Coord.snap(x, 100);
            y = Geda3.Coord.snap(y, 100);
        }


        /**
         * Convert user coordinates to device coordinates
         *
         * @param ux The user x coordinate
         * @param uy The user y coordinate
         * @param dx The device x coordinate
         * @param dy The device y coordinate
         */
        public void user_to_device(
            double ux,
            double uy,
            out double dx,
            out double dy
            )

        {
            var x = ux;
            var y = uy;

            matrix.transform_point(ref x, ref y);

            dx = x;
            dy = y;
        }

        /**
         * Zoom to a box
         *
         * @param x0 The x coordinate of the first corner
         * @param y0 The y coordinate of the first corner
         * @param x1 The x coordinate of the second corner
         * @param y1 The y coordinate of the second corner
         */
        public void zoom_box(double x0, double y0, double x1, double y1)

            requires(drawing != null)

        {
            var dx = Math.fabs(x1 - x0);
            var dy = Math.fabs(y1 - y0);

            if ((dx >= 1.0) && (dy >= 1.0))
            {
                var width = drawing.get_allocated_width();
                var height = drawing.get_allocated_height();

                var zoom_x = width / dx;
                var zoom_y = height / dy;

                var zoom = double.min(zoom_x, zoom_y);

                var center_x = (x1 + x0) / 2.0;
                var center_y = (y1 + y0) / 2.0;

                zoom_point(
                    (int) Math.round(center_x),
                    (int) Math.round(center_y),
                    zoom
                    );
            }
        }


        /**
         * Zoom the schematic to fit the view
         */
        public void zoom_extents()

            requires(drawing != null)

        {
            zoom_extents_no_redraw();

            drawing.queue_draw();
        }


        /**
         * Zoom in on the center of the window
         */
        public void zoom_in_center()

            requires(drawing != null)

        {
            var width = drawing.get_allocated_width();
            var height = drawing.get_allocated_height();

            zoom_in_point(width / 2, height / 2);
        }


        /**
         * Zoom in and center point in window
         *
         * @param x The center point in device units
         * @param y The center point in device units
         */
        public void zoom_in_point(int x, int y)
        {
            zoom_point(x, y, 1.25);
        }


        /**
         * Zoom out on the center of the window
         */
        public void zoom_out_center()

            requires(drawing != null)

        {
            var width = drawing.get_allocated_width();
            var height = drawing.get_allocated_height();

            zoom_out_point(width / 2, height / 2);
        }
        

        /**
         * Zoom out and center point in window
         *
         * @param x The center point in device units
         * @param y The center point in device units
         */
        public void zoom_out_point(int x, int y)
        {
            zoom_point(x, y, 0.8);
        }


        /**
         * The backing store for the schematic window settings
         *
         * Use the property accessor to update this field. The property
         * accessor will ensure the signals are disconnected from the
         * previous settings and connected to the new settings.
         */
        private SchematicWindowSettings b_settings;


        /**
         * Indicates the schematic should be zoomed on initial draw
         */
        private bool m_initial_zoom = true;


        /**
         *
         */
        private Gee.Set<Geda3.SchematicItem> m_selected;


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
        // temporarily public
        public Geda3.Schematic schematic;


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
         *
         *
         * @param next_file the file to read the schematic from
         */
        private bool on_button_press_event(Gdk.EventButton event)
        {
            // temporary until better solution
            drawing.grab_focus();

            return tool_button_press_event(event);
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        private bool on_button_release_event(Gdk.EventButton event)
        {
            return tool_button_release_event(event);
        }


        /**
         * Event handler for when the color scheme changes
         *
         * @param scheme The new color scheme
         */
        public void on_color_scheme_changed(Geda3.ColorScheme scheme)
        {
            color_scheme_changed(scheme);
        }


        /**
         * Draw the schematic window contents
         */
        private bool on_draw(Cairo.Context context)

            requires(painter != null)
            //requires(m_current_tool != null)
            requires(b_settings != null)
            requires(schematic != null)

        {
            painter.pango_context = Pango.cairo_create_context(context);
            Pango.cairo_context_set_resolution(painter.pango_context, 936);

            if (m_initial_zoom)
            {
                zoom_extents_no_redraw();

                m_initial_zoom = false;
            }
            
            var background = b_settings.scheme[0];

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

            context.translate(0.5, 0.5);

            painter.matrix0 = context.get_matrix();
            painter.matrix1 = matrix;

            context.transform(matrix);

            b_settings.grid.draw(context, b_settings.scheme);

            painter.cairo_context = context;
            painter.color_scheme = b_settings.scheme;

            schematic.draw(
                painter,
                m_selected,
                b_settings.reveal
                );

            draw_tool(painter);

            painter.cairo_context = null;

            return true;
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        private bool on_key_press_event(Gdk.EventKey event)
        {
            return tool_key_press_event(event);
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        private bool on_key_release_event(Gdk.EventKey event)
        {
            return tool_key_release_event(event);
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        private bool on_motion_notify_event(Gdk.EventMotion event)
        {
            return tool_motion_notify_event(event);
        }


        /**
         * A signal handler for when settings change
         *
         * @param spec unused
         */
        private void on_notify_settings(ParamSpec spec)
        {
            queue_draw();
        }


        /**
         *
         */
        private void pan_displacement(int dx, int dy)
        {
            matrix.x0 += dx;
            matrix.y0 += dy;

            drawing.queue_draw();
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


        /**
         * Zoom the schematic to fit the view without a redraw
         */
        private void zoom_extents_no_redraw()

            requires(b_settings != null)
            requires(drawing != null)
            requires(painter != null)
            requires(schematic != null)

        {
            matrix = Cairo.Matrix.identity();

            var width = drawing.get_allocated_width();
            var height = drawing.get_allocated_height();

            if ((width > 0) && (height > 0))
            {
                matrix.translate(
                    Math.round(width / 2.0),
                    Math.round(height / 2.0)
                    );

                var bounds = schematic.calculate_bounds(
                    painter,
                    b_settings.reveal
                    );

                if (bounds.empty())
                {
                    bounds = Geda3.Bounds()
                    {
                        min_x = -500,
                        min_y = -500,
                        max_x = 1500,
                        max_y = 1500
                    };
                }

                var initial_scale = double.min(
                    0.9 * width / (bounds.max_x - bounds.min_x).abs(),
                    0.9 * height / (bounds.max_y - bounds.min_y).abs()
                    );

                var final_scale = Math.floor(100.0 * initial_scale) / 100.0;

                matrix.scale(final_scale, -final_scale);

                matrix.translate(
                    (bounds.max_x + bounds.min_x) / -2.0,
                    (bounds.max_y + bounds.min_y) / -2.0
                    );

                matrix.x0 = Math.round(matrix.x0);
                matrix.y0 = Math.round(matrix.y0);
            }
        }


        /**
         * Zoom in or out and center a point in window
         *
         * Zoom factors less than 1.0 result in zooming in. Zoom
         * factors greater than 1.0 result in zooming out. The zoom
         * factor must be a positive value.
         *
         * Setting the zoom factor to 1.0 provides a panning operation.
         * In this case, the given coordinates will be moved to the
         * center of the screen and the zoom will remain unchanged.
         *
         * @param x The x coordinate of the zoom point, in device units
         * @param y The y coordinate of the zoom point, in device units
         * @param factor The zoom factor
         */
        private void zoom_point(int x, int y, double factor)

            requires(drawing != null)
            requires(factor > 0.0)

        {
            var inverse = matrix;
            var status = inverse.invert();

            return_if_fail(status == Cairo.Status.SUCCESS);

            var scale = Math.floor(factor * 100.0 * matrix.xx);
            scale = scale.clamp(4.0, 125.0);
            scale /= (100.0 * matrix.xx);

            matrix.scale(scale, scale);

            int width = drawing.get_allocated_width();
            int height = drawing.get_allocated_height();

            matrix.x0 = (int) Math.round(width / 2.0);
            matrix.y0 = (int) Math.round(height / 2.0);

            double dx = x;
            double dy = y;

            inverse.transform_point(ref dx, ref dy);

            matrix.translate(-dx, -dy);

            matrix.x0 = Math.round(matrix.x0);
            matrix.y0 = Math.round(matrix.y0);

            drawing.queue_draw();
        }
    }
}
