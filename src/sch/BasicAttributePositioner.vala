namespace Geda3
{
    /**
     *
     */
    public class BasicAttributePositioner : Object,
        AttributePositioner
    {
        /**
         * {@inheritDoc}
         */
        public void adjust_bus_net(
            int x0,
            int y0,
            int x1,
            int y1,
            TextItem item
            )
        {
            if ((x0 < x1) || (y0 < y1))
            {
                adjust2(x0, y0, x1, y1, item);
            }
            else if ((x0 != x1) || (y0 != y1))
            {
                adjust2(x1, y1, x0, y0, item );
            }
        }

        /**
         * "Indent" from the endpoint of the bus or net
         */
        private int m_dx = 100;


        /**
         * Distance from the bus or net to the baseline
         */
        private int m_dy = 50;


        /**
         *
         */
        private double m_t = 0.0;


        /**
         *
         */
        private void adjust2(
            int x0,
            int y0,
            int x1,
            int y1,
            TextItem item
            )
        {
            var length = Coord.distance(x0, y0, x1, y1);

            var ux = (x1 - x0) / length;
            var uy = (y1 - y0) / length;

            var ix0 = (ux * m_dx) - (uy * m_dy) + x0;
            var iy0 = (ux * m_dy) + (uy * m_dx) + y0;

            ux = -ux;

            var ix1 = (ux * m_dx) + (uy * m_dy) + x0;
            var iy1 = (uy * m_dx) + (ux * m_dy) + y0;

            var ix = (ix1 - ix0) * m_t + ix0;
            var iy = (iy1 - iy0) * m_t + iy0;

            item.x = (int) Math.round(ix);
            item.y = (int) Math.round(iy);

            var theta = Math.atan2(
                y1 - y0,
                x1 - x0
                );

            item.angle = Angle.normalize(Angle.from_radians(theta));
        }
    }
}
