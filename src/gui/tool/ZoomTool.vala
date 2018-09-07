namespace Gschem3
{
    /**
     * A tool for zooming in on a specific area
     *
     * The zoom tool uses different behavior when activated by an
     * action or a hotkey.
     *
     * When activated by an action, the user presses the mouse button
     * to start the operation. The mouse button is kept pressed and
     * the box is dragged to the desired area. Releasing the mouse
     * button zooms to the area.
     *
     * When activated by a hotkey, the mouse location when the hotkey
     * is pressed is used as the initial location. The box is dragged
     * to the desired area. Pressing the mouse button zooms to the
     * area.
     *
     * After the zoom operation completes, the select tool is selected.
     *
     * Pressing the hotkey in the middle of the operation starts the
     * operation again from the beginning.
     *
     * Pressing escape cancels the operation and selects the select
     * tool.
     */
    public class ZoomTool : DrawingTool
    {
        /**
         * Initialize a new zoom tool
         *
         * @param window The window this zoom tool manipulates
         */
        public ZoomTool(SchematicWindow window)
        {
            base(window);
            
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)
        {
            if (m_state == State.S0)
            {
                reset_with_point(event.x, event.y);
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
                m_x[1] = event.x;
                m_y[1] = event.y;

                update();

                m_window.zoom_box(m_x[0], m_y[0], m_x[1], m_y[1]);

                m_window.select_tool(SELECT_NAME);
            }

            m_state = State.S0;

            return true;
        }



        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                painter.draw_zoom_box(
                    (int) Math.round(m_x[0]),
                    (int) Math.round(m_y[0]),
                    (int) Math.round(m_x[1]),
                    (int) Math.round(m_y[1])
                    );
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
                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);

                m_x[1] = event.x;
                m_y[1] = event.y;

                update();
            }

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            invalidate();

            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset_with_point(double x, double y)
        {
            invalidate();

            m_state = State.S1;

            m_x[0] = x;
            m_y[0] = y;

            m_x[1] = x;
            m_y[1] = y;

            update();
        }


        /**
         * {@inheritDoc}
         */
        public void update()

            requires(m_window != null)

        {
            if (m_state == State.S1)
            {
                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);
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
         * Stores the current state of the tool
         */
        private State m_state;


        /**
         * The x coordinates of the zoom box in device units
         */
        private double m_x[2];


        /**
         * The y coordinates of the zoom box in device units
         */
        private double m_y[2];


        /**
         * Redraw the current item
         */
        private void invalidate()

            requires(m_window != null)

        {
            if (m_state == State.S1)
            {
                m_window.invalidate_device(m_x[0], m_y[0], m_x[1], m_y[1]);
            }
        }
    }
}
