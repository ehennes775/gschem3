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
         * The line style
         */
        public LineStyle line_style
        {
            get
            {
                return b_line_style;
            }
            construct set
            {
                if (b_line_style != null)
                {
                    b_line_style.notify.disconnect(on_notify_style);
                }

                b_line_style = value ?? new LineStyle();

                b_line_style.notify.connect(on_notify_style);

                invalidate(this);
            }
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
         * Create a schematic box
         */
        public BoxItem()
        {
            b_lower_x = 0;
            b_lower_y = 0;
            b_upper_x = 0;
            b_upper_y = 0;
            b_color = Color.GRAPHIC;
            b_width = 10;
        }


        /**
         * Create a schematic box
         */
        public BoxItem.with_points(int x0, int y0, int x1, int y1)
        {
            b_lower_x = x0;
            b_lower_y = y0;
            b_upper_x = x1;
            b_upper_y = y1;
            b_color = Color.GRAPHIC;
            b_width = 10;
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
        public override void invalidate_on(Invalidatable invalidatable)
        {
            var bounds = Bounds.with_points(
                b_lower_x,
                b_lower_y,
                b_upper_x,
                b_upper_y
                );

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * b_width);

            bounds.expand(expand, expand);

            invalidatable.invalidate_bounds(bounds);
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(
            SchematicPainter painter,
            bool reveal,
            bool selected
            )
        {
            painter.set_cap_type(line_style.cap_type);
            painter.set_color(selected ? Geda3.Color.SELECT : b_color);
            painter.set_dash(
                line_style.dash_type,
                line_style.dash_length,
                line_style.dash_space
                );
            painter.set_width(b_width);

            painter.draw_box(b_lower_x, b_lower_y, b_upper_x, b_upper_y);
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
            line_style.cap_type = CapType.parse(params[7]);
            line_style.dash_type = DashType.parse(params[8]);
            line_style.dash_length = line_style.dash_type.parse_length(params[9]);
            line_style.dash_space = line_style.dash_type.parse_space(params[10]);
            b_fill_type = FillType.parse(params[11]);
            b_fill_width = Coord.parse(params[12]);
            b_fill_angle_1 = Angle.parse(params[13]);
            b_fill_pitch_1 = Coord.parse(params[14]);
            b_fill_angle_2 = Angle.parse(params[15]);
            b_fill_pitch_2 = Coord.parse(params[16]);
        }


        /**
         * Change a corner point on the box
         *
         * The descriptions of the corners may not match the actual
         * locations of corners. These descriptions reflect the
         * locations on a 'normal' box. Index 0 and 3 will be opposite
         * corners. Also, index 1 and 2 will be opposite corners.
         *
         * ||''index''||''Description''||
         * ||0||The lower left corner||
         * ||1||The lower right corner||
         * ||2||The upper left corner||
         * ||3||The upper right corner||
         *
         * @param index The index of the point
         * @param x The new x coordinate for the point
         * @param y The new y coordinate for the point
         */
        public void set_point(int index, int x, int y)

            requires (index >= 0)
            requires (index < 4)

        {
            invalidate(this);

            switch (index)
            {
                case 0:
                    b_lower_x = x;
                    b_lower_y = y;
                    break;

                case 1:
                    b_lower_x = x;
                    b_upper_y = y;
                    break;

                case 2:
                    b_upper_x = x;
                    b_lower_y = y;
                    break;

                case 3:
                    b_upper_x = x;
                    b_upper_y = y;
                    break;

                default:
                    return_if_reached();
                    break;
            }

            invalidate(this);
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
                line_style.cap_type,
                line_style.dash_type,
                line_style.dash_type.uses_length() ? line_style.dash_length : -1,
                line_style.dash_type.uses_space() ? line_style.dash_space : -1,
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
         * The backing store for the color
         */
        private int b_color;


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
         * The backing store for the line style
         */
        private LineStyle b_line_style;


        /**
         * The backing store for the lower x coordinate
         */
        private int b_lower_x;


        /**
         * The backing store for the lower y coordinate
         */
        private int b_lower_y;


        /**
         * The backing store for the upper x coordinate
         */
        private int b_upper_x;


        /**
         * The backing store for the upper y coordinate
         */
        private int b_upper_y;


        /**
         * The backing store for the perimeter line width
         */
        private int b_width;


        /**
         * Signal handler when a line style property changes
         */
        private void on_notify_style(ParamSpec param)
        {
            invalidate(this);
        }
    }
}
