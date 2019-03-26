namespace Gschem3
{
    /**
     *
     */
    public class NetTool : DrawingTool
    {
        /**
         * The name of the tool as found in an action parameter
         */
        public const string NAME = "net";


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
         * Create a new net drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public NetTool(SchematicWindow? window)
        {
            base(window);

            m_nets = null;
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

                foreach (var item in m_nets)
                {
                    m_window.add_item(item);
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

            requires(m_window != null)

        {
            m_state = State.S0;

            invalidate();

            m_nets = null;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                return_if_fail(m_nets != null);

                foreach (var net in m_nets)
                {
                    net.draw(painter, true, true);
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool motion_notify(Gdk.EventMotion event)

            requires(m_window != null)

        {
            base.motion_notify(event);

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

            m_nets = new Gee.ArrayList<Geda3.NetItem>();

            var middle_x = m_x[1];
            var middle_y = m_y[0];

            var length0 = (middle_x - m_x[0]) + (middle_y - m_y[0]);

            if (length0 != 0)
            {
                var net = new Geda3.NetItem.with_points(
                    m_x[0],
                    m_y[0],
                    middle_x,
                    middle_y
                    );

                m_nets.add(net);
            }

            var length1 = (m_x[1] - middle_x) + (m_y[1] - middle_y);

            if (length1 != 0)
            {
                var net = new Geda3.NetItem.with_points(
                    middle_x,
                    middle_y,
                    m_x[1],
                    m_y[1]
                    );

                m_nets.add(net);
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

            m_nets = null;
        }


        /**
         * Indicates item should reveal invisible attributes
         */
        private bool REVEAL = false;


        /**
         * The routed nets to connect the requested endpoints
         */
        private Gee.ArrayList<Geda3.NetItem> m_nets = null;


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
         * Redraw the current object
         */
        private void invalidate()

            requires(m_window != null)

        {
            var bounds = Geda3.Bounds();

            if (m_nets != null)
            {
                foreach (var net in m_nets)
                {
                    var net_bounds = Geda3.Bounds.with_points(
                        net.b_x[0],
                        net.b_y[0],
                        net.b_x[1],
                        net.b_y[1]
                        );

                    bounds.union(net_bounds);
                }

                int expand = (int) Math.ceil(0.5 * Math.SQRT2 * Geda3.NetItem.WIDTH);

                bounds.expand(expand, expand);
            }

            m_window.invalidate_user(bounds);
        }
    }
}
