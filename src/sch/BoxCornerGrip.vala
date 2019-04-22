namespace Geda3
{
    /**
     * A Grip subclass for manipulating box schematic items
     */
    public class BoxCornerGrip : Grip
    {
        /**
         * Initialize a new instance
         *
         * @param assistant Provides access to GUI functionality
         * @param common Common data shared between all grips for am item
         * @param x
         * @param y
         */
        public BoxCornerGrip(
            GripAssistant assistant,
            BoxCornerGripCommon common,
            int index_x,
            int index_y
            )
        {
            base(assistant);

            m_common = common;
            m_index_x = index_x;
            m_index_y = index_y;
            m_state = State.LOOSE;

            m_common.invalidate.connect(on_invalidate);
        }


        /**
         * {@inheritDoc}
         */
        public override bool contacts(
            double x,
            double y,
            double half_width
            )

            requires(m_assistant != null)
            requires(m_common != null)

        {
            int x0;
            int y0;

            m_common.get_point(m_index_x, m_index_y, out x0, out y0);

            double x1;
            double y1;

            m_assistant.user_to_device(
                x0,
                y0,
                out x1,
                out y1
                );

            var inside =
                (x > (x1 - half_width)) &&
                (y > (y1 - half_width)) &&
                (x < (x1 + half_width)) &&
                (y < (y1 + half_width));
                
            return inside;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(
            SchematicPainter painter,
            double half_width
            )

            requires(m_common != null)

        {
            int x;
            int y;

            m_common.get_point(m_index_x, m_index_y, out x, out y);

            painter.draw_grip(x, y, half_width);
        }


        /**
         * {@inheritDoc}
         */
        public override void drop(double x, double y)

            requires(m_common != null)
            requires(m_state == State.GRIPPED)

        {
            move(x, y);

            m_state = State.LOOSE;
        }


        /**
         * {@inheritDoc}
         */
        public override void grab(double x, double y)

            requires(m_assistant != null)
            requires(m_common != null)

        {
            warn_if_fail(m_state == State.LOOSE);

            m_assistant.device_to_user(
                x,
                y,
                out m_grab_x0,
                out m_grab_y0
                );

            m_common.get_point(
                m_index_x,
                m_index_y,
                out m_grip_x0,
                out m_grip_y0
                );

            m_state = State.GRIPPED;
        }


        /**
         * {@inheritDoc}
         */
        public override void move(double x, double y)

            requires(m_assistant != null)
            requires(m_common != null)
            requires(m_state == State.GRIPPED)

        {
            int m_grab_x1;
            int m_grab_y1;

            m_assistant.device_to_user(
                x,
                y,
                out m_grab_x1,
                out m_grab_y1
                );

            var grip_x1 = m_grab_x1 - m_grab_x0 + m_grip_x0;
            var grip_y1 = m_grab_y1 - m_grab_y0 + m_grip_y0;

            m_assistant.snap_point(ref grip_x1, ref grip_y1);

            m_common.set_point(
                m_index_x,
                m_index_y,
                grip_x1,
                grip_y1
                );
        }


        /**
         *
         */
        private enum State
        {
            LOOSE,
            GRIPPED
        }


        /**
         * Common data shared between all grips for am item
         */
        private BoxCornerGripCommon m_common;


        /**
         * The user x coordinate of the pointer when grabbed
         */
        private int m_grab_x0;

        /**
         * The user y coordinate of the pointer when grabbed
         */
        private int m_grab_y0;


        /**
         * The user x coordinate of the point when it was grabbed
         */
        private int m_grip_x0;


        /**
         * The user y coordinate of the point when it was grabbed
         */
        private int m_grip_y0;


        /**
         * The index of the point to manipulate
         */
        private int m_index_x;


        /**
         * The index of the point to manipulate
         */
        private int m_index_y;


        /**
         * The state of the grip
         */
        private State m_state;


        /**
         * Invalidate this grip
         */
        private void on_invalidate()

            requires(m_assistant != null)
            requires(m_common != null)

        {
            int x;
            int y;

            m_common.get_point(m_index_x, m_index_y, out x, out y);

            m_assistant.invalidate_square_grip(x, y);
        }
    }
}
