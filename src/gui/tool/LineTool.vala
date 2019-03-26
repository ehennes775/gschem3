namespace Gschem3
{
    /**
     * A tool for drawing graphic lines on the schematic
     */
    public class LineTool : DrawingTool
    {
       /**
        * The name of the tool as found in an action parameter
        */
        public const string NAME = "line";


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
         * Create a new line drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        public LineTool(SchematicWindow? window)
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

                line = new Geda3.LineItem.with_points(
                    ix,
                    iy,
                    ix,
                    iy
                    );

                m_state = State.S1;
            }
            else if (m_state == State.S1)
            {
                return_val_if_fail(b_line != null, false);

                m_x = event.x;
                m_y = event.y;

                update();

                m_window.add_item(line);

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
            line = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                return_if_fail(b_line != null);

                b_line.draw(painter, true, true);
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
            line = null;
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
                return_if_fail(b_line != null);

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                // The c function for set_points inside
                // SchematicItemLine seem to disappear when implementing
                // the interface. So, this workaround calls the function
                // through the interface.

                (b_line as Geda3.GrippablePoints).set_point(1, ix, iy);
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
         * The line currently being drawn
         */
        private Geda3.LineItem b_line = null;


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
        private Geda3.LineItem line
        {
            get
            {
                return b_line;
            }
            set
            {
                if (b_line != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_line, REVEAL);
                    }

                    b_line.invalidate.disconnect(on_invalidate);
                }

                b_line = value;

                if (b_line != null)
                {
                    return_if_fail(m_window != null);

                    b_line.invalidate.connect(on_invalidate);
                    m_window.invalidate_item(b_line, REVEAL);
                }
            }
        }


        /**
         * Redraw the current item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(b_line == item)
            requires(m_window != null)

        {
            m_window.invalidate_item(b_line, REVEAL);
        }
    }
}
