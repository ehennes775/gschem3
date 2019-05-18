namespace Geda3
{
    /**
     * Represents a graphical path on a schematic or symbol
     */
    public class PathItem : SchematicItem,
        Colorable,
        Fillable,
        Grippable,
        StylableLine
    {
        /**
         * The type code, for a path, used in schematic files
         */
        public const string TYPE_ID = "H";


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
         * Initialize the class
         */
        static construct
        {
        }


        /**
         * Initialize the instance
         */
        construct
        {
            b_commands = new Gee.ArrayList<PathCommand>();
            b_converter = new PathCommandConverter1();
        }


        /**
         * Create a text item
         */
        public PathItem()
        {
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            )

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))

        {
            var bounds = Bounds();
            var context = PathContext();

            foreach (var command in b_commands)
            {
                command.build_bounds(ref context, ref bounds);
            }

            var expand = (int) Math.ceil(0.5 * Math.SQRT2 * b_width);

            bounds.expand(expand, expand);

            return bounds;
        }


        /**
         * {@inheritDoc}
         */
        public Gee.Collection<Grip> create_grips(
            GripAssistant assistant
            )

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))

        {
            var grips = new Gee.ArrayList<Grip>();

            foreach (var command in b_commands)
            {
                command.build_grips(assistant, grips);
            }

            return grips;
        }


        /**
         * {@inheritDoc}
         */
        public override void invalidate_on(Invalidatable invalidatable)
        {
        }


        /**
         * {@inheritDoc}
         */
        public override bool locate_insertion_point(
            out int x,
            out int y
            )

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))

        {
            var context = PathContext();
            var success = false;
            var temp_x = int.MAX;
            var temp_y = int.MAX;

            foreach (var command in b_commands)
            {
                int command_x;
                int command_y;

                var command_success = command.locate_insertion_point(
                    ref context,
                    out command_x,
                    out command_y
                    );

                if (command_success)
                {
                    temp_x = int.min(temp_x, command_x);
                    temp_y = int.min(temp_y, command_y);

                    success = true;
                }
            }

            x = temp_x;
            y = temp_y;

            return success;
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

            painter.draw_path(b_commands);
        }


        /**
         * {@inheritDoc}
         */
        public override bool intersects_box(
            SchematicPainter painter,
            Bounds box
            )
        {
            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_x(int cx)

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))

        {
            invalidate(this);

            foreach (var command in b_commands)
            {
                command.mirror_x(cx);
            }

            invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_y(int cy)

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))

        {
            invalidate(this);

            foreach (var command in b_commands)
            {
                command.mirror_y(cy);
            }

            invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
            if (params.length != 14)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Path with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_color = Color.parse(params[1]);
            b_width = Coord.parse(params[2]);

            b_line_style.set_from_params(params[3:7]);

            b_fill_style.set_from_params(params[7:13]);

            var line_count = Coord.parse(params[13]);

            var lines = new string[line_count];

            for (int index = 0; index < line_count; index++)
            {
                lines[index] = stream.read_line(null);
            }

            b_commands = b_converter.convert_from_lines(lines);
        }


        /**
         * {@inheritDoc}
         */
        public override void rotate(int cx, int cy, int angle)

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))

        {
            invalidate(this);

            foreach (var command in b_commands)
            {
                command.rotate(cx, cy, angle);
            }

            invalidate(this);
        }


        /**
         * Change a point on the path
         *
         * ||''index''||''Description''||
         *
         * @param index The index of the point
         * @param x The new x coordinate for the point
         * @param y The new y coordinate for the point
         */
        public void set_point(int index, int x, int y)

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))
            requires(index == 0)

        {
            invalidate(this);

            // modify points

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
            return_val_if_fail(b_commands != null, double.MAX);

            var distance = double.MAX;
            var context = PathContext();

            foreach (var command in b_commands)
            {
                var temp_distance = command.shortest_distance(
                    ref context,
                    x,
                    y
                    );

                distance = double.min(distance, temp_distance);
            }

            return distance;
        }


        /**
         * {@inheritDoc}
         */
        public override void translate(int dx, int dy)

            requires(b_commands != null)
            requires(b_commands.all_match(c => c != null))

        {
            invalidate(this);

            foreach (var command in b_commands)
            {
                command.translate(dx, dy);
            }

            invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var lines = b_converter.convert_to_lines(b_commands);

            var output = "%s %d %d %d %d %d %d %d %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_color,
                b_width,
                b_line_style.cap_type,
                b_line_style.dash_type,
                b_line_style.dash_type.uses_length() ? b_line_style.dash_length : -1,
                b_line_style.dash_type.uses_space() ? b_line_style.dash_space : -1,
                b_fill_style.fill_type,
                b_fill_style.fill_type.uses_first_set() ? b_fill_style.fill_width : -1,
                b_fill_style.fill_type.uses_first_set() ? b_fill_style.fill_angle_1 : -1,
                b_fill_style.fill_type.uses_first_set() ? b_fill_style.fill_pitch_1 : -1,
                b_fill_style.fill_type.uses_second_set() ? b_fill_style.fill_angle_2 : -1,
                b_fill_style.fill_type.uses_second_set() ? b_fill_style.fill_pitch_2 : -1,
                lines.length
                );

            stream.write_all(output.data, null);

            for (int index = 0; index < lines.length; index++)
            {
                stream.put_string(lines[index]);
                stream.put_string("\n");
            }
        }


        /**
         * Backing store for the color
         */
        private int b_color;


        /**
         * Backing store for the path commands
         */
        private Gee.List<PathCommand> b_commands;


        /**
         * 
         */
        private PathCommandConverter b_converter;


        /**
         * The backing store for the fill style
         */
        private FillStyle b_fill_style;


        /**
         * The backing store for the line style
         */
        private LineStyle b_line_style;


        /**
         * The backing store for the perimeter line width
         */
        private int b_width;


        /**
         * Signal handler when the fill or line style property changes
         */
        private void on_notify_style(ParamSpec param)
        {
            invalidate(this);
        }
    }
}
