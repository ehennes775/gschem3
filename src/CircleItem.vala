namespace Geda3
{
    /**
     * Schematic circle
     *
     * Represents a graphic circle on a schematic
     *
     *
     * || 0||string||The constant 'V' indicating a circle            ||
     * || 1||int32 ||X coordinate of the center                      ||
     * || 2||int32 ||Y coordinate of the center                      ||
     * || 3||int32 ||Radius of the circle                            ||
     * || 4||int32 ||Color index                                     ||
     * || 5||int32 ||Width of the perimeter line                     ||
     * || 6||int32 ||Not used                                        ||
     * || 7||int32 ||The type of dash to use                         ||
     * || 8||int32 ||The length of the dashes                        ||
     * || 9||int32 ||The spacing between the dashes                  ||
     * ||10||int32 ||The fill type to use                            ||
     * ||11||int32 ||The width of the fill lines                     ||
     * ||12||int32 ||The angle of the first set of fill lines        ||
     * ||13||int32 ||The spacing between the first set of fill lines ||
     * ||14||int32 ||The angle of the second set of fill lines       ||
     * ||15||int32 ||The spacing between the second set of fill lines||
     */
    public class CircleItem : SchematicItem
    {
        /**
         * The type code used in schematic files
         */
        public const string TYPE_ID = "V";


        /**
         * Create a schematic bus
         */
        public CircleItem()
        {
            b_center_x = 0;
            b_center_y = 0;
            b_radius = 0;
            b_color = Color.GRAPHIC;
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(SchematicPainter painter)
        {
            var bounds = Bounds.with_points(
                b_center_x - b_radius,
                b_center_y - b_radius,
                b_center_x + b_radius,
                b_center_y + b_radius
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
        public override void read(DataInputStream stream) throws IOError, ParseError
        {
            var input = stream.read_line(null);

            var params = input.split(" ");

            if (params.length != 16)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Circle with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_center_x = Coord.parse(params[1]);
            b_center_y = Coord.parse(params[2]);
            b_radius = Coord.parse(params[3]);
            b_color = Color.parse(params[4]);
            b_width = Coord.parse(params[5]);
            b_line_cap = CapType.parse(params[6]);
            b_dash_type = DashType.parse(params[7]);
            b_dash_length = b_dash_type.parse_length(params[8]);
            b_dash_space = b_dash_type.parse_space(params[9]);
            b_fill_type = FillType.parse(params[10]);
            b_fill_width = Coord.parse(params[11]);
            b_fill_angle_1 = Angle.parse(params[12]);
            b_fill_pitch_1 = Coord.parse(params[13]);
            b_fill_angle_2 = Angle.parse(params[14]);
            b_fill_pitch_2 = Coord.parse(params[15]);
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_center_x,
                b_center_y,
                b_radius,
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
         * Backing store for the center x coordinate
         *
         * Temporarily public for testing
         */
        public int b_center_x;


        /**
         * Backing store for the center y coordinate
         *
         * Temporarily public for testing
         */
        public int b_center_y;


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
         * Backing store for the circle radius
         *
         * Temporarily public for testing
         */
        public int b_radius;


        /**
         * Backing store for the perimeter line width
         *
         * Temporarily public for testing
         */
        public int b_width;
    }
}
