namespace Geda3
{
    /**
     * Schematic text
     *
     * Represents text or an attribute on a schematic
     */
    public class TextItem : SchematicItem, AttributeChild
    {
        /**
         * The type code, for text, used in schematic files
         */
        public const string TYPE_ID = "T";


        /**
         * The alignment of the text
         */
        public TextAlignment alignment
        {
            get
            {
                return b_alignment;
            }
            set
            {
                invalidate();

                b_alignment = value;

                invalidate();
            }
        }


        /**
         * The angle of the text in degrees
         */
        public int angle
        {
            get
            {
                return b_angle;
            }
            set
            {
                invalidate();

                b_angle = value;

                invalidate();
            }
        }


        /**
         * The entire text for this item
         */
        public string text
        {
            owned get
            {
                return string.joinv("\n", b_lines);
            }
            set
            {
                b_lines = value.split("\n");

                update_visible_text();
            }
        }


        /**
         * The presentation of the text
         */
        public TextPresentation presentation
        {
            get
            {
                return b_presentation;
            }
            set
            {
                b_presentation = value;

                update_visible_text();
            }
        }


        /**
         * The text visible on the schematic
         */
        public string visible_text
        {
            get;
            private set;
        }


        /**
         * Initialize the class
         */
        static construct
        {
            try
            {
                s_attribute_regex = new Regex("^([^=]+)=(.*)$");
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * Create a text item
         */
        public TextItem()
        {
            b_x = 0;
            b_y = 0;
            b_color = Color.TEXT;
            b_size = 12;
            b_visibility = Visibility.VISIBLE;
            b_presentation = TextPresentation.BOTH;
            b_angle = 0;
            b_alignment = TextAlignment.LOWER_LEFT;

            text = "Text";
        }


        /**
         * Create a text item
         */
        public TextItem.with_points(int x, int y, string t)
        {
            b_x = x;
            b_y = y;
            b_color = Color.TEXT;
            b_size = 12;
            b_visibility = Visibility.VISIBLE;
            b_presentation = TextPresentation.BOTH;
            b_angle = 0;
            b_alignment = TextAlignment.LOWER_LEFT;

            text = t;
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(SchematicPainter painter)
        {
            return painter.calculate_text_bounds(
                b_x,
                b_y,
                b_alignment,
                b_angle,
                b_size,
                visible_text
                );
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
        public override void draw(SchematicPainter painter, bool selected = false)
        {
            if (b_visibility == Visibility.VISIBLE)
            {
                painter.set_cap_type(CapType.NONE);
                painter.set_color(Color.MAJOR_GRID);
                painter.set_dash(DashType.SOLID, 0, 0);
                painter.set_width(10);

                painter.draw_x(b_x, b_y);

                painter.set_color(selected ? Geda3.Color.SELECT : b_color);

                painter.draw_text(
                    b_x,
                    b_y,
                    b_alignment,
                    b_angle,
                    b_size,
                    visible_text
                    );
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
            if (params.length != 10)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Text with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_x = Coord.parse(params[1]);
            b_y = Coord.parse(params[2]);
            b_color = Color.parse(params[3]);
            b_size = TextSize.parse(params[4]);
            b_visibility = Visibility.parse(params[5]);
            b_presentation = TextPresentation.parse(params[6]);
            b_angle = Angle.parse(params[7]);
            b_alignment = TextAlignment.parse(params[8]);

            var line_count = Coord.parse(params[9]);

            b_lines = new string[line_count];

            for (int index = 0; index < line_count; index++)
            {
                b_lines[index] = stream.read_line(null);
            }
        }


        /**
         * Change the insertion point of the text
         *
         * ||''index''||''Description''||
         * ||0||The insertion point of the text||
         *
         * @param index The index of the point
         * @param x The new x coordinate for the point
         * @param y The new y coordinate for the point
         */
        public void set_point(int index, int x, int y)

            requires (index == 0)

        {
            invalidate();

            b_x = x;
            b_y = y;

            invalidate();
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_x,
                b_y,
                b_color,
                b_size,
                b_visibility,
                b_presentation,
                b_angle,
                b_alignment,
                b_lines.length
                );

            stream.write_all(output.data, null);

            for (int index = 0; index < b_lines.length; index++)
            {
                stream.put_string(b_lines[index]);
                stream.put_string("\n");
            }
        }


        /**
         * A regular expression for parsing attributes
         *
         * ||''Match Group''||''Description''||
         * ||0||Entire input string||
         * ||1||Attribute name||
         * ||2||Attribute value||
         *
         * If the text does not match this regex, then the text does
         * not represent an attribute.
         */
        private static Regex s_attribute_regex;


        /**
         * Backing store for the text alignment
         *
         * Temporarily public for testing
         */
        public TextAlignment b_alignment;


        /**
         * Backing store for the text angle
         *
         * Temporarily public for testing
         */
        public int b_angle;


        /**
         *
         */
        private bool b_attribute;


        /**
         * Backing store for the color
         *
         * Temporarily public for testing
         */
        public int b_color;


        /**
         * Backing store for text
         *
         * Temporarily public for testing
         */
        public string[] b_lines;


        /**
         * Backing store for the text presentation
         *
         * Temporarily public for testing
         */
        public TextPresentation b_presentation;


        /**
         * Backing store for the text size
         *
         * Temporarily public for testing
         */
        public int b_size;


        /**
         * Backing store for the text visibility
         *
         * Temporarily public for testing
         */
        public Visibility b_visibility;


        /**
         * Backing store the insertion point x coordinate
         *
         * Temporarily public for testing
         */
        public int b_x;


        /**
         * Backing store the insertion point y coordinates
         *
         * Temporarily public for testing
         */
        public int b_y;


        /**
         *
         */
        private void update_visible_text()

            requires (b_lines != null)
            requires (s_attribute_regex != null)

        {
            invalidate();

            var local_text = string.joinv("\n", b_lines);

            MatchInfo match_info;

            b_attribute = s_attribute_regex.match(
                local_text,
                0,
                out match_info
                );

            stdout.printf(@"b_attribute = $(b_attribute)\n");
            stdout.printf(@"b_presentation = $(b_presentation)\n");

            if (b_attribute)
            {
                string? next_text;

                switch (b_presentation)
                {
                    case TextPresentation.NAME:
                        next_text = match_info.fetch(1);
                        break;

                    case TextPresentation.VALUE:
                        next_text = match_info.fetch(2);
                        break;

                    case TextPresentation.BOTH:
                    default:
                        next_text = local_text;
                        break;
                }

                return_if_fail(next_text != null);

                visible_text = next_text;

                stdout.printf(@"attribute = $(next_text)\n");
            }
            else
            {
                stdout.printf(@"plain text = $(local_text)\n");

                visible_text = local_text;
            }

            invalidate();
        }
    }
}
