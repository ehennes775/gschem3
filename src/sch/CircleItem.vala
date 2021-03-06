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
    public class CircleItem : SchematicItem,
        AdjustableColor,
        AdjustableFillStyle,
        AdjustableLineStyle,
        AdjustableRadius,
        Grippable,
        GrippablePoints
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
         * {@inheritDoc}
         */
        public int center_x
        {
            get
            {
                return b_center_x;
            }
        }


        /**
         * {@inheritDoc}
         */
        public int center_y
        {
            get
            {
                return b_center_y;
            }
        }


        /**
         * {@inheritDoc}
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
         * {@inheritDoc}
         */
        public FillStyle fill_style
        {
            get
            {
                return b_fill_style;
            }
            construct set
            {
                if (b_fill_style != null)
                {
                    b_fill_style.notify.disconnect(on_notify_style);
                }

                b_fill_style = value ?? new FillStyle();

                b_fill_style.notify.connect(on_notify_style);

                invalidate(this);
            }
        }


        /**
         * {@inheritDoc}
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
         * {@inheritDoc}
         */
        public int radius
        {
            get
            {
                return b_radius;
            }
            construct set
            {
                return_if_fail(value >= 0);

                invalidate(this);

                b_radius = value;

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
         * Create a circle item
         */
        public CircleItem()
        {
            b_center_x = 0;
            b_center_y = 0;
            b_radius = 0;
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
        public Gee.Collection<Grip> create_grips(
            GripAssistant assistant
            )
        {
            var grips = new Gee.ArrayList<Grip>();

            for (int index = 0; index < 1; index++)
            {
                grips.add(new PointGrip(assistant, this, index));
            }

            for (int angle = 0; angle < 360; angle += 90)
            {
                grips.add(new RadiusGrip(assistant, this, angle));
            }
            
            return grips;
        }


        /**
         * {@inheritDoc}
         */
        public void get_point(int index, out int x, out int y)
        {
            x = b_center_x;
            y = b_center_y;

            if (index != 0)
            {
                return_if_reached();
            }
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
            painter.set_fill_type(fill_style.fill_type);
            painter.set_width(b_width);

            painter.draw_circle(b_center_x, b_center_y, b_radius);
        }


        /**
         * {@inheritDoc}
         */
        public override bool intersects_box(
            SchematicPainter painter,
            Bounds box
            )
        {
            var x1 = double.min(box.min_x, box.max_x);
            var y1 = double.min(box.min_y, box.max_y);
            var x2 = double.max(box.min_x, box.max_x);
            var y2 = double.max(box.min_y, box.max_y);

            var dx = double.min(b_center_x - x1, x2 - b_center_x);
            var dy = double.min(b_center_y - y1, y2 - b_center_y);

            dx = double.min(dx, 0);
            dy = double.min(dy, 0);

            var shortest_distance = double.MAX;

            if (dx < 0)
            {
                if (dy < 0)
                {
                    shortest_distance = Math.hypot(dx, dy);
                }
                else
                {
                    shortest_distance = Math.fabs(dx);
                }
            }
            else
            {
                if (dy < 0)
                {
                    shortest_distance = Math.fabs(dy);
                }
                else
                {
                    shortest_distance = double.min(dx, dy);
                }
            }

            return shortest_distance <= b_radius;
        }


        /**
         * {@inheritDoc}
         */
        public override bool locate_insertion_point(
            out int x,
            out int y
            )
        {
            x = b_center_x;
            y = b_center_y;

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_x(int cx)
        {
            invalidate(this);

            b_center_x = 2 * cx - b_center_x;

            invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_y(int cy)
        {
            invalidate(this);

            b_center_y = 2 * cy - b_center_y;

            invalidate(this);
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

            line_style.set_from_params(params[6:10]);

            fill_style.set_from_params(params[10:16]);
        }


        /**
         * {@inheritDoc}
         */
        public override void rotate(int cx, int cy, int angle)
        {
            invalidate(this);

            Coord.rotate(cx, cy, angle, ref b_center_x, ref b_center_y);

            invalidate(this);
        }


        /**
         * {@inheritDoc}
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
        public override double shortest_distance(
            SchematicPainter painter,
            int x,
            int y
            )
        {
            var dx = x - b_center_x;
            var dy = y - b_center_y;

            var shortest_distance = Math.hypot(dx, dy) - b_radius;

            if (b_fill_style.fill_type != FillType.HOLLOW)
            {
                shortest_distance = double.max(shortest_distance, 0);
            }
            else
            {
                shortest_distance = Math.fabs(shortest_distance);
            }

            return shortest_distance;
        }


        /**
         * {@inheritDoc}
         */
        public override void translate(int dx, int dy)
        {
            invalidate(this);

            b_center_x += dx;
            b_center_y += dy;

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
                line_style.cap_type,
                line_style.dash_type,
                line_style.dash_type.uses_length() ? line_style.dash_length : -1,
                line_style.dash_type.uses_space() ? line_style.dash_space : -1,
                fill_style.fill_type,
                fill_style.fill_type.uses_first_set() ? fill_style.fill_width : -1,
                fill_style.fill_type.uses_first_set() ? fill_style.fill_angle_1 : -1,
                fill_style.fill_type.uses_first_set() ? fill_style.fill_pitch_1 : -1,
                fill_style.fill_type.uses_second_set() ? fill_style.fill_angle_2 : -1,
                fill_style.fill_type.uses_second_set() ? fill_style.fill_pitch_2 : -1
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
         * The backing store for the fill style
         */
        private FillStyle b_fill_style;


        /**
         * The backing store for the line style
         */
        private LineStyle b_line_style;


        /**
         * Backing store for the circle radius
         */
        private int b_radius;


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
