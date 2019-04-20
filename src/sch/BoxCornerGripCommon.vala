namespace Geda3
{
    /**
     *
     */
    public class BoxCornerGripCommon : Object
    {
        /**
         *
         */
        public signal void invalidate();


        /**
         * Initialize a new instance
         *
         * @param item
         */
        public BoxCornerGripCommon(BoxItem item)
        {
            m_item = item;

            m_item.get_corners(
                out m_x[0],
                out m_y[0],
                out m_x[1],
                out m_y[1]
                );

            m_item.invalidate.connect(on_invaliadte);
        }


        /**
         *
         */
        public void get_point(
            int index_x,
            int index_y,
            out int x,
            out int y
            )

            requires(index_x >= 0)
            requires(index_x < 2)
            requires(index_y >= 0)
            requires(index_y < 2)

        {
            x = m_x[index_x];
            y = m_y[index_y];
        }


        /**
         *
         */
        public void set_point(
            int index_x,
            int index_y,
            int x,
            int y
            )

            requires(index_x >= 0)
            requires(index_x < 2)
            requires(index_y >= 0)
            requires(index_y < 2)

        {
            invalidate();

            m_x[index_x] = x;
            m_y[index_y] = y;

            m_item.set_corners(
                m_x[0],
                m_y[0],
                m_x[1],
                m_y[1]
                );
        }


        /**
         *
         */
        private BoxItem m_item;


        /**
         *
         */
        private int m_x[2];


        /**
         *
         */
        private int m_y[2];


        /**
         *
         */
        private void on_invaliadte(SchematicItem item)

            requires(item == m_item)

        {
            invalidate();
        }
    }
}
