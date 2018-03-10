namespace Gschem3
{
    /**
     *
     */
    public class PinUpdater : Object
    {
        public PinUpdater()
        {
            m_attribute_updater = new Gee.ArrayList<PinAttributeUpdater>();

            m_attribute_updater.add(
                new PinAttributeUpdater(
                    Geda3.TextAlignment.MIDDLE_LEFT,
                    50,
                    0,
                    2,
                    "pinlabel"
                    )
                );

            m_attribute_updater.add(
                new PinAttributeUpdater(
                    Geda3.TextAlignment.LOWER_RIGHT,
                    -50,
                    50,
                    1,
                    "pinnumber"
                    )
                );

            m_attribute_updater.add(
                new PinAttributeUpdater(
                    Geda3.TextAlignment.LOWER_RIGHT,
                    -350,
                    50,
                    1,
                    "pinseq"
                    )
                );

            m_attribute_updater.add(
                new PinAttributeUpdater(
                    Geda3.TextAlignment.LOWER_RIGHT,
                    -1150,
                    50,
                    1,
                    "pintype"
                    )
                );
        }


        public void update(Geda3.PinItem pin, int[] x, int[] y)
        {
            pin.set_point(1, x[1], y[1]);

            foreach (var updater in m_attribute_updater)
            {
                updater.update(pin, x, y);
            }
        }


        private Gee.ArrayList<PinAttributeUpdater> m_attribute_updater;
    }
}
