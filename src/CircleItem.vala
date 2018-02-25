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
         * The radius for logic bubbles
         */
        public const int BUBBLE_RADIUS = 50;


        /**
         * The type code used in schematic files
         */
        public const string TYPE_ID = "V";


        /**
         * The color
         */
        public int color
        {
            get
            {
                return b_color;
            }
            set
            {
                return_if_fail(value >= 0);

                b_color = value;

                invalidate(this);
            }
            default = Color.GRAPHIC;
        }


        /**
         * The line width
         */
        public int width
        {
            get
            {
                return b_width;
            }
            set
            {
                return_if_fail(value >= 0);

                invalidate(this);

                b_width = value;

                invalidate(this);
            }
            default = 10;
        }


        /**
         * Create a schematic bus
         */
        public CircleItem()
        {
            b_center_x = 0;
            b_center_y = 0;
            b_radius = 0;
            b_color = Color.GRAPHIC;
            b_width = 10;
            //b_cap_type = CapType.NONE;
            b_dash_type = DashType.SOLID;
            b_dash_length = DashType.DEFAULT_LENGTH;
            b_dash_space = DashType.DEFAULT_SPACE;
        }


        /**
         * Create a circle representing a logic bubble
         *
         * @param x0 The x coordinate of the center of the circle
         * @param y0 The y coordinate of the center of the circle
         * @param x0 The x coordinate of the center of the circle
         * @param y0 The y coordinate of the center of the circle
         */
        public CircleItem.as_bubble(int x0, int y0, int x1, int y1)
        {
            b_radius = BUBBLE_RADIUS;

            locate_bubble(x0, y0, ref x1, ref y1);

            b_color = Color.LOGIC_BUBBLE;
            b_width = NetItem.WIDTH;
            //b_cap_type = CapType.NONE;
            b_dash_type = DashType.SOLID;
            b_dash_length = DashType.DEFAULT_LENGTH;
            b_dash_space = DashType.DEFAULT_SPACE;
        }


        /**
         * Create a circle
         *
         * @param x The x coordinate of the center of the circle
         * @param y The y coordinate of the center of the circle
         * @param radius The radius of the circle
         */
        public CircleItem.with_points(int x, int y, int radius)
        {
            b_center_x = x;
            b_center_y = y;
            b_radius = radius;
            b_color = Color.GRAPHIC;
            b_width = 10;
            //b_cap_type = CapType.NONE;
            b_dash_type = DashType.SOLID;
            b_dash_length = DashType.DEFAULT_LENGTH;
            b_dash_space = DashType.DEFAULT_SPACE;
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            )
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
        public override void invalidate_on(Invalidatable invalidatable)
        {
            var bounds = Bounds.with_points(
                b_center_x - b_radius,
                b_center_y - b_radius,
                b_center_x + b_radius,
                b_center_y + b_radius
                );

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * b_width);

            bounds.expand(expand, expand);

            invalidatable.invalidate_bounds(bounds);
        }


        /**
         *
         *
         */
        public void locate_bubble(int x0, int y0, ref int x1, ref int y1)
        {
            invalidate(this);

            var length = Coord.distance(x0, y0, x1, y1);

            var u = -1.0;
            var v = 0.0;

            if (length > 0)
            {
                u = (x0 - x1) / length;
                v = (y0 - y1) / length;
            }

            b_center_x = x1 + (int) Math.round(b_radius * u);
            b_center_y = y1 + (int) Math.round(b_radius * v);

            invalidate(this);

            x1 += (int) Math.round(2.0 * b_radius * u);
            y1 += (int) Math.round(2.0 * b_radius * v);
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter, bool selected = false)
        {
            painter.set_cap_type(b_line_cap);
            painter.set_color(selected ? Geda3.Color.SELECT : b_color);
            painter.set_dash(b_dash_type, b_dash_length, b_dash_space);
            painter.set_width(b_width);

            painter.draw_circle(b_center_x, b_center_y, b_radius);
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
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
         * Change a point on the circle
         *
         * ||''index''||''Description''||
         * ||0||The center point of the circle||
         * ||1||A point on the circumference of the circle||
         *
         * @param index The index of the point
         * @param x The new x coordinate for the point
         * @param y The new y coordinate for the point
         */
        public void set_point(int index, int x, int y)

            requires (index >= 0)
            requires (index < 2)

        {
            invalidate(this);

            if (index == 0)
            {
                b_center_x = x;
                b_center_y = y;
            }
            else if (index == 1)
            {
                b_radius = (int) Math.round(Coord.distance(b_center_x, b_center_y, x, y));
            }
            else
            {
                return_if_reached();
            }

            invalidate(this);
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
