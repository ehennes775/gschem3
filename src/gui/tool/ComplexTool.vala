namespace Gschem3
{
    /**
     *
     */
    public class ComplexTool : DrawingTool
    {
        /**
         * Create a new complex drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public ComplexTool(SchematicWindow window)
        {
            base(window);

            // temp for development
            complex = new Geda3.ComplexItem.with_name(m_library, "ech-crystal-4.sym");
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)

            requires(m_window != null)

        {
            if (complex != null)
            {
                m_window.add_item(complex);
            }

            // temp for development
            complex = new Geda3.ComplexItem.with_name(m_library, "ech-crystal-4.sym");

            m_x = event.x;
            m_y = event.y;

            update();

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void cancel()
        {
            //complex = null;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (b_complex != null)
            {
                b_complex.draw(painter, true, true);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool key_pressed(Gdk.EventKey event)
        {
            if (complex != null)
            {
                uint keyval;

                if (event.get_keyval(out keyval))
                {
                    if (keyval == Gdk.Key.i)
                    {
                        complex.mirror_x();
                    }
                    else if (keyval == Gdk.Key.r)
                    {
                        complex.angle = Geda3.Angle.normalize(complex.angle + 90);
                    }
                    else if (keyval == Gdk.Key.R)
                    {
                        complex.angle = Geda3.Angle.normalize(complex.angle - 90);
                    }
                }
            }

            return base.key_pressed(event);
        }


        /**
         * {@inheritDoc}
         */
        public override bool motion_notify(Gdk.EventMotion event)
        {
            base.motion_notify(event);

            m_x = event.x;
            m_y = event.y;

            update();

            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            //complex = null;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset_with_point(double x, double y)

            requires(m_window != null)

        {
            m_x = x;
            m_y = y;
        }


        /**
         * Process the drawing operation with the last event coordinates
         *
         * This function can be called when something can change the
         * drawing operation in progress. For example, if the user
         * changes the snap mode. This function update the drawing
         * operation to accomodate the new snap mode without an
         * additional event.
         */
        public void update()

            requires(m_window != null)

        {
            if (b_complex != null)
            {
                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                b_complex.set_point(0, ix, iy);
            }
        }


        /**
         * The complex item currently being placed
         */
        private Geda3.ComplexItem? b_complex = null;


        // temp located here for development
        private static Geda3.ComplexLibrary m_library = new Geda3.ComplexLibrary();


        /**
         * The x coordinate of the last event in device coordinates
         */
        private double m_x;


        /**
         * The y coordinate of the last event in device coordinates
         */
        private double m_y;


        /**
         * The complex item currently being drawn
         */
        private Geda3.ComplexItem? complex
        {
            get
            {
                return b_complex;
            }
            set
            {
                if (b_complex != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_complex);
                    }

                    b_complex.invalidate.disconnect(on_invalidate);
                }

                b_complex = value;

                if (b_complex != null)
                {
                    b_complex.invalidate.connect(on_invalidate);

                    return_if_fail(m_window != null);
                    m_window.invalidate_item(b_complex);
                }
            }
        }


        /**
         * Redraw the current item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(b_complex == item)
            requires(m_window != null)

        {
            m_window.invalidate_item(b_complex);
        }
    }
}
