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
                m_x = event.x;
                m_y = event.y;

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                box = new Geda3.BoxItem.with_points(
                    ix,
                    iy,
                    ix,
                    iy
                    );

                m_state = State.S1;
            }
            else if (m_state == State.S1)
            {
                return_val_if_fail(b_box != null, false);

                m_x = event.x;
                m_y = event.y;

                update();

                m_window.add_item(box);

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
            box = null;
            m_state = State.S0;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainterCairo painter)
        {
            if (m_state == State.S1)
            {
                return_if_fail(b_box != null);

                b_box.draw(painter, true);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool motion_notify(Gdk.EventMotion event)
        {
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
            box = null;
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
                return_if_fail(b_box != null);

                var x = m_x;
                var y = m_y;

                m_window.device_to_user(ref x, ref y);

                var ix = (int) Math.round(x);
                var iy = (int) Math.round(y);

                m_window.snap_point(ref ix, ref iy);

                b_box.set_point(3, ix, iy);
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
         * The box currently being drawn
         */
        private Geda3.BoxItem b_box = null;


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
         * Stores the document window this tool is drawing into
         */
        private weak SchematicWindow m_window;


        /**
         * The box currently being drawn
         */
        private Geda3.BoxItem box
        {
            get
            {
                return b_box;
            }
            set
            {
                if (b_box != null)
                {
                    if (m_window != null)
                    {
                        m_window.invalidate_item(b_box);
                    }

                    b_box.invalidate.disconnect(on_invalidate);
                }

                b_box = value;

                if (b_box != null)
                {
                    return_if_fail(m_window != null);

                    b_box.invalidate.connect(on_invalidate);
                    m_window.invalidate_item(b_box);
                }
            }
        }


        /**
         * Redraw the current item
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(b_box == item)
            requires(m_window != null)

        {
            m_window.invalidate_item(b_box);
        }
    }
}
