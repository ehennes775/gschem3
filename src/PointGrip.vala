namespace Geda3
{
    /**
     *
     */
    public class PointGrip : Grip
    {
        /**
         *
         */
        public PointGrip(GrippablePoints item, int index)
        {
            m_index = index;
            m_item = item;
        }


        /**
         *
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
         *
         */
        private int m_index;


        /**
         *
         */
        private GrippablePoints m_item;
    }
}
