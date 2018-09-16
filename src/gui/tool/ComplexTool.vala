namespace Gschem3
{
    /**
     * Places complex items onto a schematic
     */
    public class ComplexTool : DrawingTool
    {
        /**
         * The factory for creating complex items to place
         */
        private ComplexFactory factory
        {
            get
            {
                return b_factory;
            }
            protected set
            {
                return_if_fail(value != null);

                if (b_factory != null)
                {
                    b_factory.recreate.disconnect(on_recreate);
                }

                b_factory = value;

                b_factory.recreate.connect(on_recreate);

                complex = b_factory.create();
            }
        }


        /**
         * Create a new complex drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public ComplexTool(SchematicWindow window, ComplexFactory factory)
        {
            base(window);

            this.factory = factory;

            reset();
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)

            requires(b_factory != null)
            requires(m_window != null)

        {
            if (b_complex != null)
            {
                m_window.add_item(b_complex);
            }

            complex = b_factory.create();

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
            m_state = State.S0;

            if (b_complex != null)
            {
                m_window.invalidate_item(b_complex, b_reveal);

                // temporary until additional functionality is added
                // probably when implementing the delete operation
                foreach (var attribute in b_complex.attributes)
                {
                    m_window.invalidate_item(attribute, b_reveal);
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if ((m_state == State.S1) && (b_complex != null))
            {
                b_complex.draw(painter, b_reveal, true);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool key_pressed(Gdk.EventKey event)
        {
            if (b_complex != null)
            {
                uint keyval;

                if (event.get_keyval(out keyval))
                {
                    if (keyval == Gdk.Key.i)
                    {
                        b_complex.mirror_x(b_complex.insert_x);

                        return true;
                    }
                    else if (keyval == Gdk.Key.I)
                    {
                        b_complex.mirror_y(b_complex.insert_y);

                        return true;
                    }
                    else if (keyval == Gdk.Key.r)
                    {
                        b_complex.rotate(
                            b_complex.insert_x,
                            b_complex.insert_y,
                            90
                            );

                        return true;
                    }
                    else if (keyval == Gdk.Key.R)
                    {
                        b_complex.rotate(
                            b_complex.insert_x,
                            b_complex.insert_y,
                            -90
                            );

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

                var dx = ix - b_complex.insert_x;
                var dy = iy - b_complex.insert_y;

                b_complex.translate(dx, dy);
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
         * The backing store for the complex item currently being placed
         */
        private Geda3.ComplexItem? b_complex = null;


        /**
         * The backing store for factory to create items to place
         */
        private ComplexFactory b_factory;


        /**
         * Temporary for development. This should move into a settings
         * object.
         *
         * Indicates the complex item being placed should reveal the
         * invisible attributes.
         */
        private bool b_reveal = true;


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
                        m_window.invalidate_item(b_complex, b_reveal);
                    }

                    b_complex.invalidate.disconnect(on_invalidate);
                }

                b_complex = value;

                if (b_complex != null)
                {
                    b_complex.invalidate.connect(on_invalidate);

                    return_if_fail(m_window != null);
                    m_window.invalidate_item(b_complex, b_reveal);
                }
            }
        }


        /**
         * Redraw the current item ar child attribute
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(m_window != null)

        {
            m_window.invalidate_item(item, b_reveal);
        }


        /**
         * Recreate the complex item to incorporate changes
         */
        private void on_recreate()

            requires(b_factory != null)

        {
            complex = b_factory.create();
        }
    }
}
