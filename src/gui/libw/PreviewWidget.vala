namespace Gschem3
{
    /**
     * Provides a preview for a schematic or symbol
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/libw/PreviewWidget.ui.xml")]
    public class PreviewWidget : Gtk.Bin
    {
        /**
         * The schematic or symbol to preview
         */
        public Geda3.Schematic? schematic
        {
            get;
            set;
            default = null;
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
            construct set
            {
                if (b_settings != null)
                {
                    b_settings.notify.disconnect(on_notify_settings);
                }

                b_settings = value ?? SchematicWindowSettings.get_default();

                return_if_fail(b_settings != null);

                b_settings.notify.connect(on_notify_settings);
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
            m_drawing.add_events(
                Gdk.EventMask.STRUCTURE_MASK
                );

            m_drawing.configure_event.connect(on_configure_event);
            m_drawing.draw.connect(on_draw);
            notify["schematic"].connect(on_notify_schematic);
        }


        /**
         * Asynchronously load and preview a schematic or symbol file
         *
         * @param file The schematic or symbol file to preview
         */
        public void load(File? file)
        {
            schematic = null;

            if (file != null)
            {
                if (m_cancel != null)
                {
                    m_cancel.cancel();
                }

                m_cancel = new Cancellable();

                fetch.begin(file, m_cancel, (object, result) =>
                    {
                        try
                        {
                            schematic = fetch.end(result);
                        }
                        catch (IOError error)
                        {
                            if (!(error is IOError.CANCELLED))
                            {
                                throw error;
                            }
                        }
                        catch (Error error)
                        {
                            warning(error.message);
                        }
                    });
            }
        }


        /**
         * The backing store for the schematic window settings
         *
         * Use the property accessor to update this field. The property
         * accessor will ensure the signals are disconnected from the
         * previous settings and connected to the new settings.
         */
        private SchematicWindowSettings b_settings = null;


        /**
         * For cancelling the background async function
         */
        private Cancellable m_cancel = null;


        /**
         * A GtkTreeView widget containing the project
         */
        [GtkChild(name="preview-drawing")]
        private Gtk.DrawingArea m_drawing;


        /**
         * Indicates the schematic should be zoomed on initial draw
         */
        private bool m_initial_zoom = true;


        /**
         * Matrix for converting drawing to window coordinates
         */
        private Cairo.Matrix m_matrix = Cairo.Matrix.identity();


        /**
         * The painter used to draw schematics
         */
        private Geda3.SchematicPainterCairo m_painter = new Geda3.SchematicPainterCairo();


        /**
         * Fetch the contents of the schematic or symbol file asynchronously
         *
         * @param file The schematic file to load
         * @param cancel To cancel the operation
         */
        private async Geda3.Schematic fetch(File file, Cancellable cancel) throws Error
        {
            var schematic = new Geda3.Schematic();

            yield schematic.read_from_file_async(file, cancel);

            return schematic;
        }


        /**
         * Signal handler for when widget gets resized
         *
         * @param event unused
         */
        private bool on_configure_event(Gdk.EventConfigure event)
        {
            m_initial_zoom = true;

            m_drawing.queue_draw();

            return false;
        }


        /**
         * Draw the schematic window contents
         */
        private bool on_draw(Cairo.Context context)

            requires(m_drawing != null)
            requires(m_painter != null)
            requires(b_settings != null)

        {
            m_painter.pango_context = Pango.cairo_create_context(context);
            Pango.cairo_context_set_resolution(m_painter.pango_context, 936);

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
                m_drawing.get_allocated_width(),
                m_drawing.get_allocated_height()
                );

            context.fill();

            // Assigning an uninvertable matrix to a cairo context
            // causes other widgets to fail during redraw. This check
            // ensures a failure in this widget does not propagate to
            // other widgets.
            var temp_matrix = m_matrix;
            var status = temp_matrix.invert();
            return_val_if_fail(status == Cairo.Status.SUCCESS, true);

            context.translate(0.5, 0.5);

            m_painter.matrix0 = context.get_matrix();
            m_painter.matrix1 = m_matrix;

            context.transform(m_matrix);

            b_settings.grid.draw(
                context,
                b_settings.scheme,
                GridSize.DEFAULT
                );

            m_painter.cairo_context = context;
            m_painter.color_scheme = b_settings.scheme;

            if (schematic != null)
            {
                schematic.draw(
                    m_painter,
                    Gee.Set<Geda3.SchematicItem>.empty(),
                    b_settings.reveal
                    );
            }
            
            m_painter.cairo_context = null;

            return true;
        }


        /**
         * Signal handler for when the schematic changes
         *
         * @param param unused
         */
        private void on_notify_schematic(ParamSpec param)
        {
            m_initial_zoom = true;

            m_drawing.queue_draw();
        }


        /**
         * A signal handler for when settings change
         *
         * @param spec unused
         */
        private void on_notify_settings(ParamSpec spec)
        {
            m_initial_zoom = true;

            m_drawing.queue_draw();
        }


        /**
         * Zoom the schematic to fit the view without a redraw
         */
        private void zoom_extents_no_redraw()

            requires(b_settings != null)
            requires(m_drawing != null)
            requires(m_painter != null)

        {
            m_matrix = Cairo.Matrix.identity();

            var width = m_drawing.get_allocated_width();
            var height = m_drawing.get_allocated_height();

            if ((width > 0) && (height > 0))
            {
                m_matrix.translate(
                    Math.round(width / 2.0),
                    Math.round(height / 2.0)
                    );

                var bounds = Geda3.Bounds();

                if (schematic != null)
                {
                    bounds = schematic.calculate_bounds(
                        m_painter,
                        b_settings.reveal
                        );
                }

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

                m_matrix.scale(final_scale, -final_scale);

                m_matrix.translate(
                    (bounds.max_x + bounds.min_x) / -2.0,
                    (bounds.max_y + bounds.min_y) / -2.0
                    );

                m_matrix.x0 = Math.round(m_matrix.x0);
                m_matrix.y0 = Math.round(m_matrix.y0);
            }
        }
    }
}
