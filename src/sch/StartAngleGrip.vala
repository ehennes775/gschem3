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
        protected override void adjust_angle(int angle)

            requires(m_item != null)

        {
            m_item.start_angle = Angle.normalize(angle);
        }


        /**
         * {@inheritDoc}
         */
        protected override int calculate_angle()

            requires(m_item != null)

        {
            return m_item.start_angle;
        }


        /**
         * {@inheritDoc}
         */
        protected override double calculate_offset()
        {
            return 15.0;
        }
    }
}
