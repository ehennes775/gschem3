namespace Geda3
{
    /**
     * A schematic arc item
     *
     * Represents a graphical arc in a schematic or symbol
     *
     *
     * || 0||string||The constant 'A' indicating an arc||
     * || 1||int32 ||X coordinate of the center        ||
     * || 2||int32 ||Y coordinate of the center        ||
     * || 3||int32 ||Radius of the circle              ||
     * || 4||int32 ||Start angle                       ||
     * || 5||int32 ||Sweep angle                       ||
     * || 6||int32 ||Color index                       ||
     * || 7||int32 ||Width of the perimeter line       ||
     * || 8||int32 ||Not used                          ||
     * || 9||int32 ||The type of dash to use           ||
     * ||10||int32 ||The length of the dashes          ||
     * ||11||int32 ||The spacing between the dashes    ||
     */
    public class ArcItem : SchematicItem
    {
        /**
         * The type code used in schematic files
         */
        public const string TYPE_ID = "A";


        /**
         * The color
         */
        public int color
        {
            get
            {
                return b_color;
            }
            construct set
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
            construct set
            {
                return_if_fail(value >= 0);

                invalidate(this);

                b_width = value;

                invalidate(this);
            }
            default = 10;
        }


        /**
         * Create an arc item
         */
        public ArcItem()
        {
            b_center_x = 0;
            b_center_y = 0;
            b_radius = 0;
            b_start_angle = 0;
            b_sweep_angle = 0;
        }


        /**
         * Create a circle
         *
         * @param x The x coordinate of the center of the arc
         * @param y The y coordinate of the center of the arc
         * @param radius The radius of the arc
         * @param start_angle The starting angle of the sweep
         * @param sweep_angle The degress of sweep
         */
        public ArcItem.with_points(
            int x,
            int y,
            int radius,
            int start_angle,
            int sweep_angle
            )
        {
            b_center_x = x;
            b_center_y = y;
            b_radius = radius;
            b_start_angle = start_angle;
            b_sweep_angle = sweep_angle;
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            )
        {
            var radians0 = Angle.to_radians(b_start_angle);
            var radians1 = Angle.to_radians(b_start_angle + b_sweep_angle);

            var x0 = b_center_x + b_radius * Math.cos(radians0);
            var y0 = b_center_x + b_radius * Math.sin(radians0);

            var x1 = b_center_x + b_radius * Math.cos(radians1);
            var y1 = b_center_x + b_radius * Math.sin(radians1);

            var bounds = Bounds.with_fpoints(x0, y0, x1, y1);

            double start;
            double end;

            if (b_sweep_angle >= 0)
            {
                start = Angle.normalize(b_start_angle);
                end = start + b_sweep_angle;
            }
            else
            {
                start = Angle.normalize(b_start_angle + b_sweep_angle);
                end = start - b_sweep_angle;
            }

            if (start < 90 && end > 90)
            {
                bounds.max_y = b_center_y + b_radius;
            }

            if (start < 180 && end > 180)
            {
                bounds.min_x = b_center_x - b_radius;
            }

            if (start < 270 && end > 270)
            {
                bounds.min_y = b_center_y - b_radius;
            }

            if (start < 360 && end < 360)
            {
                bounds.max_x = b_center_x + b_radius;
            }

            var expand = (int) Math.ceil(0.5 * Math.SQRT2 * b_width);

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

            painter.draw_arc(
                b_center_x,
                b_center_y,
                b_radius,
                b_start_angle,
                b_sweep_angle
                );
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
            if (params.length != 12)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Arc with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_center_x = Coord.parse(params[1]);
            b_center_y = Coord.parse(params[2]);
            b_radius = Coord.parse(params[3]);
            b_start_angle = Coord.parse(params[4]);
            b_sweep_angle = Coord.parse(params[5]);
            b_color = Color.parse(params[6]);
            b_width = Coord.parse(params[7]);

            line_style.set_from_params(params[8:12]);
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
            var output = "%s %d %d %d %d %d %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_center_x,
                b_center_y,
                b_radius,
                b_start_angle,
                b_sweep_angle,
                b_color,
                b_width,
                line_style.cap_type,
                line_style.dash_type,
                line_style.dash_type.uses_length() ? line_style.dash_length : -1,
                line_style.dash_type.uses_space() ? line_style.dash_space : -1
                );

            stream.write_all(output.data, null);
        }


        /**
         * Backing store for the center x coordinate
         */
        private int b_center_x;


        /**
         * Backing store for the center y coordinate
         */
        private int b_center_y;


        /**
         * Backing store the color
         */
        private int b_color;


        /**
         * The backing store for the line style
         */
        private LineStyle b_line_style;


        /**
         * Backing store for the circle radius
         */
        private int b_radius;


        /**
         * The backing store for the start angle
         */
        private int b_start_angle;


        /**
         * The backing store for the sweep_angle
         */
        private int b_sweep_angle;


        /**
         * Backing store for the perimeter line width
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