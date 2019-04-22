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
        protected override void adjust_angle(int angle)

            requires(m_item != null)

        {
            var sweep = Angle.calc_sweep(m_item.start_angle, angle);

            if (sweep == 0)
            {
                sweep = 360;
            }

            if (Sweep.is_clockwise(m_item.sweep_angle))
            {
                sweep = Sweep.reverse(sweep);
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
