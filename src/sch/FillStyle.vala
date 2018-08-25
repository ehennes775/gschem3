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
         * Set the fill style using parameters
         *
         * Uses parameters, as from an input file, to set the fill
         * style. If an error occurs parsing the parameters, the fill
         * style will remain unchanged.
         *
         * ||0||Fill type||
         * ||1||Width||
         * ||2||Angle 1||
         * ||3||Pitch 1||
         * ||4||Angle 2||
         * ||5||Pitch 2||
         *
         * @param params The parameters
         * @throw ParseError A parameter was invalid
         */
        public void set_from_params(string[] params) throws ParseError

            requires(params.length == 6)

        {
            var temp_fill_type = FillType.parse(params[0]);

            var temp_fill_width = FillStyle.DEFAULT_WIDTH;
            var temp_fill_angle_1 = FillStyle.DEFAULT_ANGLE_1;
            var temp_fill_pitch_1 = FillStyle.DEFAULT_PITCH_1;

            if (temp_fill_type.uses_first_set())
            {
                temp_fill_width = Coord.parse(params[1]);
                temp_fill_angle_1 = Angle.parse(params[2]);
                temp_fill_pitch_1 = Coord.parse(params[3]);
            }

            var temp_fill_angle_2 = FillStyle.DEFAULT_ANGLE_2;
            var temp_fill_pitch_2 = FillStyle.DEFAULT_PITCH_2;

            if (temp_fill_type.uses_second_set())
            {
                temp_fill_angle_2 = Angle.parse(params[4]);
                temp_fill_pitch_2 = Coord.parse(params[5]);
            }

            fill_type = temp_fill_type;
            fill_angle_1 = temp_fill_angle_1;
            fill_pitch_1 = temp_fill_pitch_1;
            fill_angle_2 = temp_fill_angle_2;
            fill_pitch_2 = temp_fill_pitch_2;
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

