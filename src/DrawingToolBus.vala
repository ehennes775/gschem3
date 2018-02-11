namespace Gschem3
{
    /**
     *
     */
    public class DrawingToolBus : DrawingTool
    {
        /**
         * Create a new bus drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public DrawingToolBus(SchematicWindow window)
        {
            m_busses = null;
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
                m_state = State.S1;

                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_x[0] = (int) Math.round(x);
                m_y[0] = (int) Math.round(y);

                m_window.snap_point(ref m_x[0], ref m_y[0]);

                m_x[1] = m_x[0];
                m_y[1] = m_y[0];

                update();
            }
            else if (m_state == State.S1)
            {
                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_x[1] = (int) Math.round(x);
                m_y[1] = (int) Math.round(y);

                m_window.snap_point(ref m_x[1], ref m_y[1]);

                update();

                // temporary code until a mechanism to stop drawing
                // nets becomes available

                foreach (var item in m_busses)
                {
                    m_window.add_item(item);
                }

                reset();
            }
            else
            {
                return_if_reached();
            }

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void cancel()

            requires(m_window != null)

        {
            m_state = State.S0;

            invalidate();

            m_busses = null;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                return_if_fail(m_busses != null);

                foreach (var net in m_busses)
                {
                    net.draw(painter, true);
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool motion_notify(Gdk.EventMotion event)

            requires(m_window != null)

        {
            if (m_state == State.S1)
            {
                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_x[1] = (int) Math.round(x);
                m_y[1] = (int) Math.round(y);

                m_window.snap_point(ref m_x[1], ref m_y[1]);

                update();
            }

            return false;
        }


        /**
         * {@inheritDoc}
         */
        public void update()
        {
            invalidate();

            m_busses = new Gee.ArrayList<Geda3.BusItem>();

            var middle_x = m_x[1];
            var middle_y = m_y[0];

            var length0 = (middle_x - m_x[0]) + (middle_y - m_y[0]);

            if (length0 != 0)
            {
                var net = new Geda3.BusItem.with_points(
                    m_x[0],
                    m_y[0],
                    middle_x,
                    middle_y
                    );

                m_busses.add(net);
            }

            var length1 = (m_x[1] - middle_x) + (m_y[1] - middle_y);

            if (length1 != 0)
            {
                var net = new Geda3.BusItem.with_points(
                    middle_x,
                    middle_y,
                    m_x[1],
                    m_y[1]
                    );

                m_busses.add(net);
            }

            invalidate();
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            m_state = State.S0;

            invalidate();

            m_busses = null;
        }


        /**
         * The routed nets to connect the requested endpoints
         */
        private Gee.ArrayList<Geda3.BusItem> m_busses = null;


        /**
         * The x coordinates of the requested net endpoints
         *
         * These coordinates are in user coordinates
         */
        private int m_x[2];


        /**
         * The y coordinates of the requested net endpoints
         *
         * These coordinates are in user coordinates
         */
        private int m_y[2];


        /**
         * States of the drawing tool
         */
        private enum State
        {
            S0,
            S1
        }


        /**
         * Stores the current state of the tool
         */
        private State m_state;


        /**
         * Stores the document window this tool is drawing into
         */
        private weak SchematicWindow m_window;


        /**
         * Redraw the current object
         */
        private void invalidate()

            requires(m_window != null)

        {
            var bounds = Geda3.Bounds();

            if (m_busses != null)
            {
                foreach (var bus in m_busses)
                {
                    var bus_bounds = Geda3.Bounds.with_points(
                        bus.b_x[0],
                        bus.b_y[0],
                        bus.b_x[1],
                        bus.b_y[1]
                        );

                    bounds.union(bus_bounds);
                }
            }

            m_window.invalidate_user(bounds);
        }
    }
}
