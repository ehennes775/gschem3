namespace Gschem3
{
    /**
     *
     */
    public class DrawingToolPin : DrawingTool
    {
        /**
         * Create a new pin drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public DrawingToolPin(SchematicWindow window)
        {
            m_state = State.S0;
            m_window = window;
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)

            requires(m_window != null)

        {
            if (m_state == State.S0)
            {
                m_x = event.x;
                m_y = event.y;

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                pin = new Geda3.SchematicItemPin.with_points(
                    ix,
                    iy,
                    ix,
                    iy
                    );

                pin_name = new Geda3.TextItem.with_points(
                    ix + 50,
                    iy,
                    "RESET"
                    );

                pin_name.b_alignment = Geda3.TextAlignment.MIDDLE_LEFT;

                pin_number = new Geda3.TextItem.with_points(
                    ix - 50,
                    iy - 50,
                    "13"
                    );

                pin_number.b_alignment = Geda3.TextAlignment.LOWER_RIGHT;
                pin_number.b_color = Geda3.Color.ATTRIBUTE;

                m_state = State.S1;
            }
            else if (m_state == State.S1)
            {
                return_val_if_fail(b_pin != null, false);

                m_x = event.x;
                m_y = event.y;

                update();

                pin.attach(pin_name);
                pin.attach(pin_number);
                m_window.add_item(pin);

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
            pin = null;
            pin_name = null;
            pin_number = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                return_if_fail(b_pin != null);

                b_pin.draw(painter, true);
                b_pin_name.draw(painter, true);
                b_pin_number.draw(painter, true);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool motion_notify(Gdk.EventMotion event)
        {
            if (m_state == State.S1)
            {
                m_x = event.x;
                m_y = event.y;

                update();
            }

            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            pin = null;
            pin_name = null;
            pin_number = null;
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
                return_if_fail(b_pin != null);

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                b_pin.set_point(1, ix, iy);

                var dx = b_pin.b_x[1] - b_pin.b_x[0];
                var dy = b_pin.b_y[1] - b_pin.b_y[0];
                var radians = Math.atan2(dy, dx);
                var degrees = Geda3.Angle.from_radians(radians);
                var normal = Geda3.Angle.normalize(degrees);

                if ((normal > 90) && (normal <= 270))
                {
                    b_pin_name.angle = 180 + degrees;
                    b_pin_name.alignment = Geda3.TextAlignment.MIDDLE_RIGHT;
                }
                else
                {
                    b_pin_name.angle = degrees;
                    b_pin_name.alignment = Geda3.TextAlignment.MIDDLE_LEFT;
                }

                var tx = ix + (int) Math.round(50 * Math.cos(radians));
                var ty = iy + (int) Math.round(50 * Math.sin(radians));

                b_pin_name.set_point(0, tx, ty);

                if ((normal > 90) && (normal <= 270))
                {
                    b_pin_number.angle = 180 + degrees;
                    b_pin_number.alignment = Geda3.TextAlignment.LOWER_LEFT;

                    var nx = ix + (int) Math.round(-50 * Math.cos(radians) + 50 * Math.sin(radians));
                    var ny = iy + (int) Math.round(-50 * Math.sin(radians) - 50 * Math.cos(radians));

                    b_pin_number.set_point(0, nx, ny);
                }
                else
                {
                    b_pin_number.angle = degrees;
                    b_pin_number.alignment = Geda3.TextAlignment.LOWER_RIGHT;

                    var nx = ix + (int) Math.round(-50 * Math.cos(radians) - 50 * Math.sin(radians));
                    var ny = iy + (int) Math.round(-50 * Math.sin(radians) + 50 * Math.cos(radians));

                    b_pin_number.set_point(0, nx, ny);
                }

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
         * The pin currently being drawn
         */
        private Geda3.SchematicItemPin b_pin = null;


        /**
         * The pin name currently being drawn
         */
        private Geda3.TextItem b_pin_name = null;


        /**
         * The pin number currently being drawn
         */
        private Geda3.TextItem b_pin_number = null;


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
         * Stores the document window this tool is drawing into
         */
        private weak SchematicWindow m_window;


        /**
         * The pin currently being drawn
         */
        private Geda3.SchematicItemPin pin
        {
            get
            {
                return b_pin;
            }
            set
            {
                if (b_pin != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_pin);
                    }

                    b_pin.invalidate.disconnect(on_invalidate);
                }

                b_pin = value;

                if (b_pin != null)
                {
                    return_if_fail(m_window != null);

                    b_pin.invalidate.connect(on_invalidate);
                    m_window.invalidate_item(b_pin);
                }
            }
        }


        /**
         * The pin name currently being drawn
         */
        private Geda3.TextItem pin_name
        {
            get
            {
                return b_pin_name;
            }
            set
            {
                if (b_pin_name != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_pin_name);
                    }

                    b_pin_name.invalidate.disconnect(on_invalidate);
                }

                b_pin_name = value;

                if (b_pin_name != null)
                {
                    return_if_fail(m_window != null);

                    b_pin_name.invalidate.connect(on_invalidate);
                    m_window.invalidate_item(b_pin_name);
                }
            }
        }


        /**
         * The pin name currently being drawn
         */
        private Geda3.TextItem pin_number
        {
            get
            {
                return b_pin_number;
            }
            set
            {
                if (b_pin_number != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_pin_number);
                    }

                    b_pin_number.invalidate.disconnect(on_invalidate);
                }

                b_pin_number = value;

                if (b_pin_number != null)
                {
                    return_if_fail(m_window != null);

                    b_pin_number.invalidate.connect(on_invalidate);
                    m_window.invalidate_item(b_pin_number);
                }
            }
        }


        /**
         * Add the hidden attributes to the pin
         *
         * @param pin
         */
        private void add_hidden(Geda3.SchematicItemPin pin)
        {
        }


        /**
         * Redraw the current item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(item != null)
            requires(m_window != null)

        {
            m_window.invalidate_item(item);
        }
    }
}
