namespace Geda3
{
    /**
     * The fill style for graphic items
     *
     * Since the fill style does not change the bounds of the object,
     * items can use the notify signal from these properties to
     * determine when to invalidate.
     */
    public class FillStyle : Object
    {
        /**
         * The default first fill angle
         */
        public static const int DEFAULT_ANGLE_1 = 45;


        /**
         * The default second fill angle
         */
        public static const int DEFAULT_ANGLE_2 = 135;


        /**
         * The first fill pitch
         */
        public static const int DEFAULT_PITCH_1 = 50;


        /**
         * The second fill pitch
         */
        public static const int DEFAULT_PITCH_2 = 50;


        /**
         * The default width
         */
        public static const int DEFAULT_WIDTH = 10;


        /**
         * The first fill angle
         */
        public int fill_angle_1
        {
            get
            {
                return b_fill_angle_1;
            }
            construct set
            {
                b_fill_angle_1 = value;
            }
            default = DEFAULT_ANGLE_1;
        }


        /**
         * The second fill angle
         */
        public int fill_angle_2
        {
            get
            {
                return b_fill_angle_2;
            }
            construct set
            {
                b_fill_angle_2 = value;
            }
            default = DEFAULT_ANGLE_2;
        }


        /**
         * The first fill pitch
         */
        public int fill_pitch_1
        {
            get
            {
                return b_fill_pitch_1;
            }
            construct set
            {
                return_if_fail(value >= 0);

                b_fill_pitch_1 = value;
            }
            default = DEFAULT_PITCH_1;
        }


        /**
         * The second fill pitch
         */
        public int fill_pitch_2
        {
            get
            {
                return b_fill_pitch_2;
            }
            construct set
            {
                return_if_fail(value >= 0);

                b_fill_pitch_2 = value;
            }
            default = DEFAULT_PITCH_2;
        }


        /**
         * The type of fill for the item
         */
        public FillType fill_type
        {
            get
            {
                return b_fill_type;
            }
            construct set
            {
                return_if_fail(value >= 0);
                return_if_fail(value < FillType.COUNT);

                b_fill_type = value;
            }
            default = FillType.HOLLOW;
        }


        /**
         * The second fill pitch
         */
        public int fill_width
        {
            get
            {
                return b_fill_width;
            }
            construct set
            {
                return_if_fail(value >= 0);

                b_fill_width = value;
            }
            default = DEFAULT_WIDTH;
        }


        /**
         * Backing store for the first fill angle
         */
        private int b_fill_angle_1;


        /**
         * Backing store the second fill angle
         */
        private int b_fill_angle_2;


        /**
         * Backing store for the first fill pitch
         */
        private int b_fill_pitch_1;


        /**
         * Backing store for the second fill pitch
         */
        private int b_fill_pitch_2;


        /**
         * Backing store for the fill type
         */
        private FillType b_fill_type;


        /**
         * Backing store fill line width
         */
        private int b_fill_width;
    }
}

