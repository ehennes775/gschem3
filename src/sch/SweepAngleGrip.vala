namespace Geda3
{
    /**
     * A Grip subclass for manipulating the sweep angle of an arc
     */
    public class SweepAngleGrip : AngleGrip
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
         * {@inheritDoc}
         */
        protected override int calculate_angle()

            requires(m_item != null)

        {
            return m_item.start_angle + m_item.sweep_angle;
        }


        /**
         * {@inheritDoc}
         */
        protected override double calculate_offset()
        {
            return 30.0;
        }
    }
}
