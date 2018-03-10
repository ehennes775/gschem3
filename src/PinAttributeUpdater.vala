namespace Gschem3
{
    /**
     *
     */
    public class PinAttributeUpdater : Object
    {
        /**
         *
         */
        public Geda3.TextAlignment alignment
        {
            get;
            set;
        }


        /**
         *
         */
        public int dx
        {
            get;
            set;
        }


        /**
         *
         */
        public int dy
        {
            get;
            set;
        }


        /**
         *
         */
        public int index
        {
            get;
            set;
        }


        /**
         *
         */
        public string name
        {
            get;
            set;
        }


        /**
         *
         *
         * @param alignment
         * @param dx
         * @param dy
         * @param name
         */
        public PinAttributeUpdater(
            Geda3.TextAlignment alignment,
            int dx,
            int dy,
            int index,
            string name
            )

        {
            this.alignment = alignment;
            this.dx = dx;
            this.dy = dy;
            this.index = index;
            this.name = name;
        }


        /**
         * Update the positioning of a pin attribute
         *
         * This function updates the following text properties:
         *
         * - alignment
         * - angle
         * - x insertion point
         * - y insertion point
         *
         * If the attribute is not attached to the pin, this function
         * does nothing.
         *
         * @param pin The pin with the attribute to update
         */
        public void update(Geda3.PinItem pin, int[] x, int[] y)
        {
            var attribute = pin.get_attribute(name);

            if (attribute != null)
            {
                var dx1 = x[1] - x[0];
                var dy1 = y[1] - y[0];

                var radians = Math.atan2(dy1, dx1);
                var degrees = Geda3.Angle.from_radians(radians);
                var normal = Geda3.Angle.normalize(degrees);

                int my;

                if ((normal > 90) && (normal <= 270))
                {
                    attribute.angle = 180 + degrees;
                    attribute.alignment = alignment.mirror_x();
                    my = -1;
                }
                else
                {
                    attribute.angle = degrees;
                    attribute.alignment = alignment;
                    my = 1;
                }

                var tx = x[index] + (int) Math.round(dx * Math.cos(radians) - my * dy * Math.sin(radians));
                var ty = y[index] + (int) Math.round(dx * Math.sin(radians) + my * dy * Math.cos(radians));

                attribute.set_point(0, tx, ty);
            }
        }
    }
}

