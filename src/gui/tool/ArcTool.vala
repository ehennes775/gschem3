namespace Gschem3
{
    /**
     *
     */
    public class ArcTool : DrawingTool
    {
        /**
         * The name of the tool as found in an action parameter
         */
        public const string NAME = "arc";


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
         * Create a new arc drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public ArcTool(SchematicWindow? window = null)
        {
            base(window);

            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)

            requires(m_window != null)

        {
            if (m_state == State.S0)
            {
                reset_with_point(event.x, event.y);
            }
            else if (m_state == State.S1)
            {
                m_x = event.x;
                m_y = event.y;

                update();

                m_state = State.S2;
            }
            else if (m_state == State.S2)
            {
                return_val_if_fail(b_arc != null, false);

                m_x = event.x;
                m_y = event.y;

                update();

                m_window.add_item(arc);

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
            arc = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state != State.S0)
            {
                return_if_fail(b_arc != null);

                b_arc.draw(painter, true, true);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool key_pressed(Gdk.EventKey event)
        {
            if (m_state != State.S0)
            {
                return_if_fail(b_arc != null);

                uint keyval;

                if (event.get_keyval(out keyval))
                {
                    if (keyval == Gdk.Key.slash)
                    {
                        b_arc.reverse();
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

            if (m_state != State.S0)
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
            arc = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset_with_point(double x, double y)

            requires(m_window != null)

        {
            m_x = x;
            m_y = y;

            m_window.device_to_user(ref x, ref y);

            var ix = (int) Math.round(x);
            var iy = (int) Math.round(y);

            m_window.snap_point(ref ix, ref iy);

            arc = new Geda3.ArcItem.with_points(
                ix,
                iy,
                0,
                0,
                180
                );

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
            if (m_state == State.S1)
            {
                return_if_fail(b_arc != null);

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                b_arc.set_point(1, ix, iy);
            }
            else if (m_state == State.S2)
            {
                return_if_fail(b_arc != null);

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                b_arc.set_point(2, ix, iy);
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
            S1,
            S2
        }


        /**
         * The arc currently being drawn
         */
        private Geda3.ArcItem b_arc = null;


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
         * The arc currently being drawn
         */
        private Geda3.ArcItem arc
        {
            get
            {
                return b_arc;
            }
            set
            {
                if (b_arc != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_arc, REVEAL);
                    }

                    b_arc.invalidate.disconnect(on_invalidate);
                }

                b_arc = value;

                if (b_arc != null)
                {
                    return_if_fail(m_window != null);

                    b_arc.invalidate.connect(on_invalidate);
                    m_window.invalidate_item(b_arc, REVEAL);
                }
            }
        }


        /**
         * Redraw the current item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(b_arc == item)
            requires(m_window != null)

        {
            m_window.invalidate_item(b_arc, REVEAL);
        }
    }
}
