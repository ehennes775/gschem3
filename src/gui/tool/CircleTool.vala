namespace Gschem3
{
    /**
     *
     */
    public class CircleTool : DrawingTool
    {
        /**
         * The name of the tool for action parameters
         */
        public const string NAME = "circle";


        /**
         * {@inheritDoc}
         */
        public override string name
        {
            get
            {
                return NAME;
            }
        }


        /**
         * Create a new circle drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public CircleTool(SchematicWindow? window = null)
        {
            base(window);

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

                circle = new Geda3.CircleItem.with_points(
                    ix,
                    iy,
                    0
                    );

                m_state = State.S1;
            }
            else if (m_state == State.S1)
            {
                return_val_if_fail(b_circle != null, false);

                m_x = event.x;
                m_y = event.y;

                update();

                m_window.add_item(circle);

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
            circle = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                return_if_fail(b_circle != null);

                b_circle.draw(painter, true, true);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool motion_notify(Gdk.EventMotion event)
        {
            base.motion_notify(event);

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
            circle = null;
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
                return_if_fail(b_circle != null);

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                b_circle.set_point(1, ix, iy);
            }
        }


        /**
         * Indicates item should reveal invisible attributes
         */
        private bool REVEAL = false;


        /**
         * States of the drawing tool
         */
        private enum State
        {
            S0,
            S1
        }


        /**
         * The circle currently being drawn
         */
        private Geda3.CircleItem b_circle = null;


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
         * The line currently being drawn
         */
        private Geda3.CircleItem circle
        {
            get
            {
                return b_circle;
            }
            set
            {
                if (b_circle != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_circle, REVEAL);
                    }

                    b_circle.invalidate.disconnect(on_invalidate);
                }

                b_circle = value;

                if (b_circle != null)
                {
                    return_if_fail(m_window != null);

                    b_circle.invalidate.connect(on_invalidate);
                    m_window.invalidate_item(b_circle, REVEAL);
                }
            }
        }


        /**
         * Redraw the current item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(b_circle == item)
            requires(m_window != null)

        {
            m_window.invalidate_item(b_circle, REVEAL);
        }
    }
}
