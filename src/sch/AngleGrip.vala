namespace Geda3
{
    /**
     * An abstract Grip subclass for manipulating arc angles
     */
    public abstract class AngleGrip : Grip
    {
        /**
         * Initialize a new instance
         *
         * @param assistant For calling functionality in the GUI
         * @param item The arc item
         */
        public AngleGrip(
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
         * Grip states
         */
        protected enum State
        {
            LOOSE,
            GRIPPED
        }


        /**
         * The item under manipulation
         */
        protected ArcItem m_item;


        /**
         * The state of the grip
         */
        protected State m_state;


        /**
         * Determine the angle of the grip
         *
         * @return The angle of the grip, in degrees
         */
        protected abstract int calculate_angle();


        /**
         * Calculate the center of the grip
         *
         * The parameters use device coordinates
         *
         * @param x The x coordinate of the center of the grip
         * @param y The y coordinate of the center of the grip
         */
        protected void calculate_grip_center(
            out double x,
            out double y
            )

            requires(m_assistant != null)
            requires(m_item != null)

        {
            var radians = Angle.to_radians(calculate_angle());

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

            var offset = calculate_offset();

            grip_x += offset * u;
            grip_y -= offset * v;

            x = grip_x;
            y = grip_y;
        }


        /**
         * Calculate the offset of the grip
         *
         * The offset of the grip ensures that grips don't overlap.
         *
         * A positive offset indicates the grip lies on the outside of
         * the shape. A negative offset indicates the grip lies on the
         * inside of the shape. With an offset of zero, the grip lies
         * on the circumference of the shape. 
         *
         * @return The offset of the grip in device coordinates
         */
        protected abstract double calculate_offset();


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
