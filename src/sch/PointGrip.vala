namespace Geda3
{
    /**
     *
     */
    public class PointGrip : Grip
    {
        /**
         *
         *
         * @param item
         * @param index
         */
        public PointGrip(GripAssistant assistant, GrippablePoints item, int index)
        {
            m_assistant = assistant;
            m_index = index;
            m_item = item;
            m_state = State.LOOSE;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter)

            requires(m_item != null)

        {
            int x;
            int y;

            m_item.get_point(m_index, out x, out y);

            painter.draw_grip(x, y);
        }


        /**
         * {@inheritDoc}
         */
        public override void drop(int x, int y)

            requires(m_item != null)
            requires(m_state == State.GRIPPED)

        {
            move(x, y);

            m_state = State.LOOSE;
        }


        /**
         * {@inheritDoc}
         */
        public override void grab(int x, int y)

            requires(m_item != null)

        {
            m_grab_x0 = x;
            m_grab_y0 = y;

            m_item.get_point(m_index, out m_grip_x0, out m_grip_y0);

            m_state = State.GRIPPED;
        }


        /**
         * {@inheritDoc}
         */
        public override void move(int x, int y)

            requires(m_item != null)
            requires(m_state == State.GRIPPED)

        {
            var grip_x1 = x - m_grab_x0 + m_grip_x0;
            var grip_y1 = y - m_grab_y0 + m_grip_y0;

            m_assistant.snap_point(ref grip_x1, ref grip_y1);

            m_item.set_point(m_index, grip_x1, grip_y1);
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
        private GripAssistant m_assistant;


        /**
         * The x coordinate of the pointer when grabbed
         */
        private int m_grab_x0;

        /**
         * The y coordinate of the pointer when grabbed
         */
        private int m_grab_y0;


        /**
         * The x coordinate of the grip when it was grabbed
         */
        private int m_grip_x0;


        /**
         * The y coordinate of the grip when it was grabbed
         */
        private int m_grip_y0;


        /**
         * The intex of the point to manipulate
         */
        private int m_index;


        /**
         * The item under manipulation
         */
        private GrippablePoints m_item;


        /**
         * The state of the grip
         */
        private State m_state;
    }
}
