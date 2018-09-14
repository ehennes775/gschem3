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
        public ComplexTool(SchematicWindow window, ComplexFactory factory)
        {
            base(window);

            m_factory = factory;
            m_factory.recreate.connect(on_recreate);

            complex = m_factory.create();
            m_state = State.S1;
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)

            requires(m_factory != null)
            requires(m_window != null)

        {
            if (b_complex != null)
            {
                m_window.add_item(b_complex);
            }

            complex = m_factory.create();

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
            m_state = State.S1;

            if (b_complex != null)
            {
                m_window.invalidate_item(b_complex);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if ((m_state == State.S1) && (b_complex != null))
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

                        return true;
                    }
                    else if (keyval == Gdk.Key.I)
                    {
                        complex.mirror_y();

                        return true;
                    }
                    else if (keyval == Gdk.Key.r)
                    {
                        complex.rotate(90);

                        return true;
                    }
                    else if (keyval == Gdk.Key.R)
                    {
                        complex.rotate(-90);

                        return true;
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
            m_state = State.S1;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset_with_point(double x, double y)

            requires(m_window != null)

        {
            m_x = x;
            m_y = y;

            m_state = State.S1;
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
         * States of the drawing tool
         */
        private enum State
        {
            S0,
            S1
        }


        /**
         * The complex item currently being placed
         */
        private Geda3.ComplexItem? b_complex = null;


        /**
         *
         */
        private ComplexFactory m_factory = new MainComplexFactory();


        /**
         * Stores the current state of the tool
         */
        private State m_state;


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


        /**
         *
         */
        private void on_recreate()

            requires(m_factory != null)

        {
            complex = m_factory.create();
        }
    }
}
