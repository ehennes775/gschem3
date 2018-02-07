namespace Gschem3
{
    /**
     * A tool for drawing graphic lines on the schematic
     */
    public class DrawingToolLine : DrawingTool
    {
        /**
         * Create a new line drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public DrawingToolLine(SchematicWindow window)
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

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                line = new Geda3.SchematicItemLine();

                line.set_point(0, ix, iy);
                line.set_point(1, ix, iy);

                m_state = State.S1;
            }
            else if (m_state == State.S1)
            {
                var x = event.x;
                var y = event.y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                line.set_point(1, ix, iy);

                m_window.add_item(line);
                line = null;
                m_state = State.S0;
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
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainter painter)
        {
            if (m_state == State.S1)
            {
                line.draw(painter);
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

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                line.set_point(1, ix, iy);
            }

            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override void reset()
        {
            m_state = State.S0;
        }


        /**
         * The x coordinates of the line endpoints
         *
         * These coordinates are in user coordinates
         *
         * In the future, these will be replaced with an instance of a
         * line object, but more functionality is required inside the
         * line object.
         */
        private int m_x[2];


        /**
         * The y coordinates of the line endpoints
         *
         * These coordinates are in user coordinates
         *
         * In the future, these will be replaced with an instance of a
         * line object, but more functionality is required inside the
         * line object.
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
         *
         */
        private Geda3.SchematicItemLine b_line;


        /**
         * Stores the current state of the tool
         */
        private State m_state;


        /**
         * Stores the document window this tool is drawing into
         */
        private weak SchematicWindow m_window;


        /**
         *
         */
        private Geda3.SchematicItemLine line
        {
            get
            {
                return b_line;
            }
            set
            {
                if (b_line != null)
                {
                    b_line.invalidate.disconnect(on_invalidate);
                }

                b_line = value;

                if (b_line != null)
                {
                    b_line.invalidate.connect(on_invalidate);
                }
            }
        }


        /**
         * Redraw the current item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(m_window != null)

        {
            m_window.invalidate_item(item);
        }
    }
}
