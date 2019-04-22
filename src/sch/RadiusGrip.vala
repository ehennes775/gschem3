namespace Geda3
{
    /**
     * A Grip subclass for manipulating a radius
     */
    public class RadiusGrip : Grip
    {
        /**
         * Initialize a new instance
         *
         * @param assistant For calling functionality in the GUI
         * @param item The item with GrippablePoints
         * @param angle
         */
        public RadiusGrip(
            GripAssistant assistant,
            AdjustableRadius item,
            int angle = 0
            )
        {
            base(assistant);

            m_item = item;
            m_state = State.LOOSE;

            var radians = Angle.to_radians(angle);

            m_cx = (int)Math.round(Math.cos(radians));
            m_cy = (int)Math.round(Math.sin(radians));

            m_item.invalidate.connect(on_invalidate);
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
            requires(m_item != null)

        {
            int x0;
            int y0;

            calculate_grip_center(out x0, out y0);

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

            requires(m_item != null)

        {
            int x;
            int y;

            calculate_grip_center(out x, out y);

            painter.draw_grip(x, y, half_width);
        }


        /**
         * {@inheritDoc}
         */
        public override void drop(double x, double y)

            requires(m_item != null)
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
            requires(m_item != null)

        {
            warn_if_fail(m_state == State.LOOSE);

            m_assistant.device_to_user(
                x,
                y,
                out m_grab_x0,
                out m_grab_y0
                );

            calculate_grip_center(out m_grip_x0, out m_grip_y0);

            m_state = State.GRIPPED;
        }


        /**
         * {@inheritDoc}
         */
        public override void move(double x, double y)

            requires(m_assistant != null)
            requires(m_item != null)
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

            var dx = grip_x1 - m_item.center_x;
            var dy = grip_y1 - m_item.center_y;

            m_assistant.snap_point(ref dx, ref dy);

            m_item.radius = (int)Math.round(Math.hypot(dx, dy));
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
         *
         */
        private int m_cx;


        /**
         *
         */
        private int m_cy;


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
        private int m_index;


        /**
         * The item under manipulation
         */
        private AdjustableRadius m_item;


        /**
         * The state of the grip
         */
        private State m_state;


        /**
         * Calculate the center of the grip
         *
         * The parameters use user coordinates
         *
         * @param x The x coordinate of the center of the grip
         * @param y The y coordinate of the center of the grip
         */
        private void calculate_grip_center(out int x, out int y)
        {
            x = m_item.center_x + m_cx * m_item.radius;
            y = m_item.center_y + m_cy * m_item.radius;
        }


        /**
         * Invalidate this grip
         */
        private void on_invalidate()

            requires(m_assistant != null)
            requires(m_item != null)

        {
            int x;
            int y;

            calculate_grip_center(out x, out y);

            m_assistant.invalidate_square_grip(x, y);
        }
    }
}
