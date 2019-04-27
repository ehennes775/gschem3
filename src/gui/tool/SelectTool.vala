namespace Gschem3
{
    /**
     *
     */
    public class SelectTool : DrawingTool,
        Geda3.GripAssistant
    {
        /**
         * The name of the tool for action parameters
         */
        public const string NAME = "select";


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
         * Create a new instance
         *
         * @param window
         */
        public SelectTool(SchematicWindow? window = null)
        {
            base(window);
            
            m_grip = null;
            m_gripped = null;
            m_grips = null;
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
                m_x[0] = event.x;
                m_y[0] = event.y;

                m_x[1] = event.x;
                m_y[1] = event.y;

                m_grip = find_grip(m_x[1], m_y[1]);

                if (m_grip != null)
                {
                    m_grip.grab(m_x[1], m_y[1]);

                    m_state = State.S4;
                }
                else
                {
                    m_state = State.S1;
                }
            }

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_released(Gdk.EventButton event)

            requires(m_window != null)

        {
            if (m_state == State.S1)
            {
                var x0 = m_x[0];
                var y0 = m_y[0];

                m_window.device_to_user(ref x0, ref y0);

                var item1 = m_window.closest_item(
                    (int)Math.round(x0),
                    (int)Math.round(y0),
                    MAX_SELECT_DISTANCE
                    );

                stdout.printf(@"event.state = $(event.state)\n");

                var toggle = (event.state & Gdk.ModifierType.CONTROL_MASK) == Gdk.ModifierType.CONTROL_MASK;

                m_window.select_item(item1, toggle);
            }
            else if (m_state == State.S2)
            {
                var x0 = m_x[0];
                var y0 = m_y[0];

                m_window.device_to_user(ref x0, ref y0);

                var x1 = m_x[1];
                var y1 = m_y[1];

                m_window.device_to_user(ref x1, ref y1);

                var min_x = (int) Math.floor(double.min(x0, x1));
                var min_y = (int) Math.floor(double.min(y0, y1));
                var max_x = (int) Math.ceil(double.max(x0, x1));
                var max_y = (int) Math.ceil(double.max(y0, y1));

                var bounds = Geda3.Bounds.with_points(
                    min_x,
                    min_y,
                    max_x,
                    max_y
                    );

                m_window.select_box(bounds);
            }
            else if (m_state == State.S4)
            {
                m_grip.drop(m_x[1], m_y[1]);
            }

            m_grip = null;
            m_state = State.S0;

            invalidate();

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void cancel()
        {
        }



        /**
         * {@inheritDoc}
         */
        public void device_to_user(
            double dx,
            double dy,
            out int ux,
            out int uy
            )
        {
            var x = dx;
            var y = dy;

            m_window.device_to_user(ref x, ref y);

            ux = (int)Math.round(x);
            uy = (int)Math.round(y);
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainter painter)
        {
            if (m_state == State.S2)
            {
                painter.draw_select_box(
                    (int) m_x[0],
                    (int) m_y[0],
                    (int) m_x[1],
                    (int) m_y[1]
                    );
            }

            if (m_grips != null)
            {
                foreach (var grip in m_grips)
                {
                    grip.draw(painter, GRIP_HALF_WIDTH);
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public void invalidate_round_grip(double x, double y)

            requires(m_window != null)

        {
            double center_x = Math.round(x);
            double center_y = Math.round(y);

            m_window.invalidate_device(
                center_x - GRIP_HALF_WIDTH,
                center_y - GRIP_HALF_WIDTH,
                center_x + GRIP_HALF_WIDTH,
                center_y + GRIP_HALF_WIDTH
                );
        }


        /**
         * {@inheritDoc}
         */
        public void invalidate_square_grip(int x, int y)

            requires(m_window != null)

        {
            double center_x;
            double center_y;

            m_window.user_to_device(
                x,
                y,
                out center_x,
                out center_y
                );

            invalidate_round_grip(center_x, center_y);
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
                m_x[1] = event.x;
                m_y[1] = event.y;

                var dx = m_x[1] - m_x[0];
                var dy = m_y[1] - m_y[0];

                var distance = Math.hypot(dx, dy);

                if (distance > BOX_DISTANCE)
                {
                    m_state = State.S2;

                    m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);
                }
            }
            else if (m_state == State.S2)
            {
                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);

                m_x[1] = event.x;
                m_y[1] = event.y;

                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);
            }
            else if (m_state == State.S4)
            {
                m_x[1] = event.x;
                m_y[1] = event.y;

                m_grip.move(m_x[1], m_y[1]);
            }

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            m_grip = null;
            m_gripped = null;
            m_grips = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public int snap_angle(int angle)

            requires(m_window != null)

        {
            return m_window.snap_angle(angle);
        }


        /**
         * {@inheritDoc}
         */
        public void snap_point(ref int x, ref int y)

            requires(m_window != null)

        {
            m_window.snap_point(ref x, ref y);
        }


        /**
         * {@inheritDoc}
         */
        public override void update_document_window(DocumentWindow? window)
        {
            if (m_window != null)
            {
                m_window.selection_changed.disconnect(
                    on_selection_changed
                    );
            }

            base.update_document_window(window);

            if (m_window != null)
            {
                m_window.selection_changed.connect(
                    on_selection_changed
                    );

                on_selection_changed();
            }
        }


        /**
         * {@inheritDoc}
         */
        public void user_to_device(
            double ux,
            double uy,
            out double dx,
            out double dy
            )

            requires(m_window != null)

        {
            m_window.user_to_device(ux, uy, out dx, out dy);
        }


        /**
         *
         * 
         */
        private const double BOX_DISTANCE = 5.0;


        /**
         * The size to use for grips
         *
         * The width and height of the grips, divided by 2, in pixels.
         */
        private const double GRIP_HALF_WIDTH = 5.0;


        /**
         *
         * 
         */
        private const double MAX_SELECT_DISTANCE = 5.0;


        /**
         * States of the drawing tool
         */
        private enum State
        {
            S0,
            S1,
            S2,
            S4
        }


        /**
         *
         */
        private Geda3.Grip? m_grip;


        /**
         *
         */
        private Gee.Collection<Geda3.Grip> m_grips;


        /**
         *
         */
        private Geda3.Grippable m_gripped;


        /**
         * Stores the current state of the tool
         */
        private State m_state;


        /**
         *
         */
        private double m_x[2];


        /**
         *
         */
        private double m_y[2];


        /**
         *
         *
         * @param x
         * @param y
         * @return
         */
        private Geda3.Grip? find_grip(double x, double y)
        {
            if (m_grips != null)
            {
                foreach (var grip in m_grips)
                {
                    if (grip == null)
                    {
                        warning("grip is null");
                    }
                    else if (grip.contacts(x, y, GRIP_HALF_WIDTH))
                    {
                        return grip;
                    }
                }
            }

            return null;
        }


        /**
         * Redraw the current item
         */
        private void invalidate()

            requires(m_window != null)

        {
            if (m_gripped != null)
            {
                m_window.invalidate_item(m_gripped, false);
            }

            if (m_state == State.S2)
            {
                m_window.invalidate_device(
                    m_x[0],
                    m_y[0],
                    m_x[1],
                    m_y[1]
                    );
            }
        }


        /**
         *
         */
        private void on_selection_changed()

            requires(m_window != null)

        {
            if (m_window.selection.size == 1)
            {
                m_gripped = m_window.selection.first_match(
                    i => i is Geda3.Grippable
                    ) as Geda3.Grippable;
            }
            else
            {
                m_gripped = null;
            }

            if (m_gripped != null)
            {
                m_grips = m_gripped.create_grips(this);
            }
            else
            {
                m_grips = null;
            }

            invalidate();
        }
    }
}
