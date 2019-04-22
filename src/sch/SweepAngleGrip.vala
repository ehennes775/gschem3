namespace Geda3
{
    /**
     * A Grip subclass for manipulating an item with GrippablePoints
     */
    public class SweepAngleGrip : Grip
    {
        /**
         * Initialize a new instance
         *
         * @param assistant For calling functionality in the GUI
         * @param item The arc item
         */
        public SweepAngleGrip(
            GripAssistant assistant,
            ArcItem item
            )
        {
            base(assistant);

            m_item = item;
            m_state = State.LOOSE;

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
            double x1;
            double y1;

            calculate_grip_center(out x1, out y1);

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
            double x;
            double y;

            calculate_grip_center(out x, out y);

            painter.draw_round_grip(x, y, half_width);
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
            double center_x;
            double center_y;

            m_assistant.user_to_device(
                m_item.center_x,
                m_item.center_y,
                out center_x,
                out center_y
                );

            var angle = Angle.from_radians(Math.atan2(
                center_y - y,
                x - center_x
                ));

            var sweep = m_assistant.snap_angle(
                Angle.calc_sweep(m_item.start_angle, angle)
                );

            if (sweep == 0)
            {
                sweep = 360;
            }

            m_item.sweep_angle = sweep;
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
         * The item under manipulation
         */
        private ArcItem m_item;


        /**
         * The state of the grip
         */
        private State m_state;


        /**
         *
         */
        private void calculate_grip_center(out double x, out double y)

            requires(m_assistant != null)
            requires(m_item != null)

        {
            var radians = Angle.to_radians(
                m_item.start_angle + m_item.sweep_angle
                );

            var u = Math.cos(radians);
            var v = Math.sin(radians);
            
            var px = m_item.center_x + m_item.radius * u;
            var py = m_item.center_y + m_item.radius * v;

            double grip_x;
            double grip_y;

            m_assistant.user_to_device(
                px,
                py,
                out grip_x,
                out grip_y
                );

            grip_x += 30.0 * u;
            grip_y -= 30.0 * v;

            x = grip_x;
            y = grip_y;
        }


        /**
         * Invalidate this grip
         */
        private void on_invalidate()

            requires(m_assistant != null)
            requires(m_item != null)

        {
            double x;
            double y;

            calculate_grip_center(out x, out y);

            m_assistant.invalidate_round_grip(x, y);
        }
    }
}
