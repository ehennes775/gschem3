namespace Geda3
{
    /**
     * Schematic box
     *
     * Represents a graphic box on a schematic
     */
    public class BoxItem : SchematicItem
    {
        /**
         * The type code used in schematic files
         */
        public const string TYPE_ID = "B";


        /**
         * Create a schematic bus
         */
        public BoxItem()
        {
            b_lower_x = 0;
            b_lower_y = 0;
            b_upper_x = 0;
            b_upper_y = 0;
            b_color = Color.GRAPHIC;
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(SchematicPainter painter)
        {
            var bounds = Bounds.with_points(
                b_lower_x,
                b_lower_y,
                b_upper_x,
                b_upper_y
                );

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * b_width);

            bounds.expand(expand, expand);

            return bounds;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter)
        {
            painter.set_cap_type(b_line_cap);
            painter.set_color(b_color);
            painter.set_dash(b_dash_type, b_dash_length, b_dash_space);
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
            if (params.length != 17)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Box with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            var corner_x = Coord.parse(params[1]);
            var corner_y = Coord.parse(params[2]);
            var width = Coord.parse(params[3]);
            var height = Coord.parse(params[4]);

            b_lower_x = int.min(corner_x, corner_x + width);
            b_lower_y = int.min(corner_y, corner_y + height);
            b_upper_x = int.max(corner_x, corner_x + width);
            b_upper_y = int.max(corner_y, corner_y + height);

            b_color = Color.parse(params[5]);
            b_width = Coord.parse(params[6]);
            b_line_cap = CapType.parse(params[7]);
            b_dash_type = DashType.parse(params[8]);
            b_dash_length = b_dash_type.parse_length(params[9]);
            b_dash_space = b_dash_type.parse_space(params[10]);
            b_fill_type = FillType.parse(params[11]);
            b_fill_width = Coord.parse(params[12]);
            b_fill_angle_1 = Angle.parse(params[13]);
            b_fill_pitch_1 = Coord.parse(params[14]);
            b_fill_angle_2 = Angle.parse(params[15]);
            b_fill_pitch_2 = Coord.parse(params[16]);
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                int.min(b_upper_x, b_lower_x),
                int.min(b_upper_y, b_lower_y),
                (b_upper_x - b_lower_x).abs(),
                (b_upper_y - b_lower_y).abs(),
                b_color,
                b_width,
                b_line_cap,
                b_dash_type,
                b_dash_type.uses_length() ? b_dash_length : -1,
                b_dash_type.uses_space() ? b_dash_space : -1,
                b_fill_type,
                b_fill_width,
                b_fill_angle_1,
                b_fill_pitch_1,
                b_fill_angle_2,
                b_fill_pitch_2
                );

            stream.write_all(output.data, null);
        }


        /**
         * Backing store the color
         *
         * Temporarily public for testing
         */
        public int b_color;


        /**
         * Backing store for the dash length
         *
         * Temporarily public for testing
         */
        public int b_dash_length;


        /**
         * Backing store for the spacing between dashes
         *
         * Temporarily public for testing
         */
        public int b_dash_space;


        /**
         * Backing store for the dash type
         *
         * Temporarily public for testing
         */
        public DashType b_dash_type;


        /**
         * Backing store for the first fill angle
         *
         * Temporarily public for testing
         */
        public int b_fill_angle_1;


        /**
         * Backing store the second fill angle
         *
         * Temporarily public for testing
         */
        public int b_fill_angle_2;


        /**
         * Backing store for the first fill pitch
         *
         * Temporarily public for testing
         */
        public int b_fill_pitch_1;


        /**
         * Backing store for the second fill pitch
         *
         * Temporarily public for testing
         */
        public int b_fill_pitch_2;


        /**
         * Backing store for the fill type
         *
         * Temporarily public for testing
         */
        public FillType b_fill_type;


        /**
         * Backing store fill line width
         *
         * Temporarily public for testing
         */
        public int b_fill_width;


        /**
         * Backing store for the line cap
         *
         * Temporarily public for testing
         */
        public CapType b_line_cap;



        /**
         * Backing store for the lower x coordinate
         *
         * Temporarily public for testing
         */
        public int b_lower_x;


        /**
         * Backing store for the lower y coordinate
         *
         * Temporarily public for testing
         */
        public int b_lower_y;


        /**
         * Backing store for the upper x coordinate
         *
         * Temporarily public for testing
         */
        public int b_upper_x;


        /**
         * Backing store for the upper y coordinate
         *
         * Temporarily public for testing
         */
        public int b_upper_y;


        /**
         * Backing store for the perimeter line width
         *
         * Temporarily public for testing
         */
        public int b_width;
    }
}
