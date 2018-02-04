namespace Gschem3
{
    /**
     *
     */
    public class DrawingToolBox : DrawingTool
    {
        /**
         * Create a new box drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public DrawingToolBox(SchematicWindow window)
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
                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_state = State.S1;
                m_x[0] = (int) Math.round(x);
                m_y[0] = (int) Math.round(y);
                m_x[1] = m_x[0];
                m_y[1] = m_y[0];

                invalidate();
            }
            else if (m_state == State.S1)
            {
                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_state = State.S0;
                m_x[1] = (int) Math.round(x);
                m_y[1] = (int) Math.round(y);

                invalidate();

                // TODO: Add new item to schematic 
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
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainter painter)
        {
            if (m_state == State.S1)
            {
                painter.set_cap_type(Geda3.CapType.NONE);
                painter.set_color(Geda3.Color.GRAPHIC);
                painter.set_dash(Geda3.DashType.SOLID, Geda3.DashType.DEFAULT_LENGTH, Geda3.DashType.DEFAULT_SPACE);
                painter.set_width(10);

                painter.draw_box(
                    m_x[0],
                    m_y[0],
                    m_x[1],
                    m_y[1]
                    );
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
                invalidate();

                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                m_x[1] = (int) Math.round(x);
                m_y[1] = (int) Math.round(y);

                invalidate();
            }

            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            m_state = State.S0;

            invalidate();
        }


        /**
         * The x coordinates of the box corners
         *
         * These coordinates are in user coordinates
         *
         * In the future, these will be replaced with an instance of a
         * box object, but more functionality is required inside the
         * box object.
         */
        private int m_x[2];


        /**
         * The y coordinates of the box corners
         *
         * These coordinates are in user coordinates
         *
         * In the future, these will be replaced with an instance of a
         * box object, but more functionality is required inside the
         * box object.
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
         * Redraw the current line object
         */
        private void invalidate()

            requires(m_window != null)

        {
            var bounds = Geda3.Bounds.with_points(
                m_x[0],
                m_y[0],
                m_x[1],
                m_y[1]
                );

            m_window.invalidate_user(bounds);
        }
    }
}
