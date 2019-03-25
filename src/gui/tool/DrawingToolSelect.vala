namespace Gschem3
{
    /**
     *
     * 
     */
    const double BOX_DISTANCE = 5.0;

    
    /**
     *
     */
    public class DrawingToolSelect : DrawingTool
    {
        public DrawingToolSelect(SchematicWindow? window)
        {
            base(window);
            
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
                m_state = State.S1;

                m_x[0] = event.x;
                m_y[0] = event.y;

                m_x[1] = event.x;
                m_y[1] = event.y;
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
                    (int)Math.round(y0)
                    );

                if (item1 != null)
                {
                    m_window.select_item(item1);
                }

                m_gripped = null;

                foreach (var item in m_window.selection)
                {
                    var grippable = item as Geda3.Grippable;

                    if (grippable != null)
                    {
                        m_gripped = grippable;
                        break;
                    }
                }

                if (m_gripped != null)
                {
                    m_grips = m_gripped.create_grips();
                }

                invalidate();
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

                //m_selected = new Gee.HashSet<Geda3.SchematicItem>();

                //m_selected.add_all(m_window.schematic.items);

                m_gripped = null;

                foreach (var item in m_window.selection)
                {
                    var grippable = item as Geda3.Grippable;

                    if (grippable != null)
                    {
                        m_gripped = grippable;
                        break;
                    }
                }

                if (m_gripped != null)
                {
                    m_grips = m_gripped.create_grips();
                }

                invalidate();
            }

            m_state = State.S0;

            return true;
        }



        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
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

            if (m_gripped != null)
            {
                m_gripped.draw(painter, true, true);
            }

            if (m_grips != null)
            {
                foreach (var grip in m_grips)
                {
                    grip.draw(painter);
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
            if (m_state == State.S2)
            {
                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);

                m_x[1] = event.x;
                m_y[1] = event.y;

                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);
            }

            return true;
        }


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
                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);
            }
        }
    }
}
