namespace Geda3
{
    /**
     * A Grip subclass for manipulating the starting angle of an arc
     */
    public class StartAngleGrip : AngleGrip
    {
        /**
         * Initialize a new instance
         *
         * @param assistant For calling functionality in the GUI
         * @param item The arc item
         */
        public StartAngleGrip(
            GripAssistant assistant,
            ArcItem item
            )
        {
            base(assistant, item);
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

            angle = Angle.normalize(m_assistant.snap_angle(angle));

            m_item.start_angle = angle;
        }


        /**
         * {@inheritDoc}
         */
        protected override void calculate_grip_center(
            out double x,
            out double y
            )

            requires(m_assistant != null)
            requires(m_item != null)

        {
            var radians = Angle.to_radians(m_item.start_angle);

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

            grip_x += 15.0 * u;
            grip_y -= 15.0 * v;

            x = grip_x;
            y = grip_y;
        }
    }
}
