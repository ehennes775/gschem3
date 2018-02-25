namespace Gschem3
{
    /**
     *
     */
    public class DrawingToolPin : DrawingTool
    {
        /**
         * The settings for this pin tool
         *
         * Setting this property to null will assign the default
         * pin tool settings.
         */
        public PinSettings settings
        {
            get
            {
                return b_settings;
            }
            set
            {
                b_settings = value ?? PinSettings.get_default();
            }
            default = null;
        }


        /**
         * Create a new pin drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public DrawingToolPin(SchematicWindow window)
        {
            base(window);

            items = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)

            requires(b_settings != null)
            requires(m_window != null)

        {
            if (m_state == State.S0)
            {
                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_x[0] = (int) Math.round(x);
                m_y[0] = (int) Math.round(y);

                m_window.snap_point(ref m_x[0], ref m_y[0]);

                items = b_settings.create_pin(m_x[0], m_y[0]);

                m_state = State.S1;
            }
            else if (m_state == State.S1)
            {
                return_val_if_fail(items != null, false);

                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_x[1] = (int) Math.round(x);
                m_y[1] = (int) Math.round(y);

                Gdk.ModifierType modifiers;

                if (event.get_state(out modifiers))
                {
                    m_ortho = (modifiers & Gdk.ModifierType.SHIFT_MASK) == 0;
                }

                update();

                m_window.add_item(items.pin);

                if (items.bubble != null)
                {
                    m_window.add_item(items.bubble);
                }
                
                reset();
            }
            else
            {
                return_val_if_reached(false);
            }

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void cancel()
        {
            items = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                return_if_fail(items != null);

                items.draw(painter, true);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool key_pressed(Gdk.EventKey event)
        {
            uint keyval;

            if (event.get_keyval(out keyval))
            {
                if (keyval == Gdk.Key.slash)
                {
                    b_settings.use_bubble = !b_settings.use_bubble;
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

            if (m_state == State.S1)
            {
                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_x[1] = (int) Math.round(x);
                m_y[1] = (int) Math.round(y);

                Gdk.ModifierType modifiers;

                if (event.get_state(out modifiers))
                {
                    m_ortho = (modifiers & Gdk.ModifierType.SHIFT_MASK) == 0;
                }

                update();
            }

            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            items = null;
            m_state = State.S0;
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
            if (m_state == State.S1)
            {
                return_if_fail(b_items != null);

                var x = m_x[1];
                var y = m_y[1];

                m_window.snap_point(ref x, ref y);

                if (m_ortho)
                {
                    Geda3.Coord.snap_ortho(m_x[0], m_y[0], ref x, ref y);
                }

                items.update(x, y);
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
         * Backing store for the current state of the tool
         */
        private PinItemGroup? b_items;


        /**
         * Backing store for the settings for the tool
         */
        private PinSettings b_settings;


        /**
         *
         */
        private bool m_ortho = true;


        /**
         * The current state of the tool
         */
        private State m_state;


        /**
         * The x coordinate of events in document coordinates
         */
        private int m_x[2];


        /**
         * The y coordinate of events in document coordinates
         */
        private int m_y[2];


        /**
         * The pin currently being drawn
         */
        private PinItemGroup? items
        {
            get
            {
                return b_items;
            }
            set
            {
                if (b_items != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_items.pin);
                    }

                    b_items.invalidate.disconnect(on_invalidate);
                }

                b_items = value;

                if (b_items != null)
                {
                    return_if_fail(m_window != null);

                    b_items.invalidate.connect(on_invalidate);
                    //m_window.invalidate_item(b_pin);
                }
            }
        }


        /**
         * Redraw an item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(item != null)
            requires(m_window != null)

        {
            m_window.invalidate_item(item);
        }
    }
}
