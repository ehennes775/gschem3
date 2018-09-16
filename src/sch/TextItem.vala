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
                return_if_fail(value >= 0);
                return_if_fail(value < TextAlignment.COUNT);

                invalidate(this);

                b_alignment = value;

                invalidate(this);
            }
            default = TextAlignment.LOWER_LEFT;
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
                invalidate(this);

                b_angle = value;

                invalidate(this);
            }
            default = 0;
        }


        /**
         * The color of the text
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
            default = Color.TEXT;
        }


        /**
         * The attribute name
         */
        public string? name
        {
            get;
            private set;
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
                return_if_fail(value >= 0);
                return_if_fail(value < TextPresentation.COUNT);

                b_presentation = value;

                update_visible_text();
            }
            default = TextPresentation.BOTH;
        }


        /**
         * The size of the text
         */
        public int size
        {
            get
            {
                return b_size;
            }
            set
            {
                return_if_fail(value >= TextSize.MIN);
                return_if_fail(value <= TextSize.MAX);

                invalidate(this);

                b_size = value;

                invalidate(this);
            }
            //Doesn't get set when specified here???
            // default = 12;
        }


        /**
         * The visible text on the schematic
         */
        public string visible_text
        {
            get;
            private set;
        }


        /**
         * The visibility of the text
         */
        public Visibility visibility
        {
            get
            {
                return b_visibility;
            }
            construct set
            {
                return_if_fail(value >= 0);
                return_if_fail(value < Visibility.COUNT);

                invalidate(this);

                b_visibility = value;

                invalidate(this);
            }
            default = Visibility.VISIBLE;
        }


        /**
         * The x coordinate of the insertion point
         */
        public int x
        {
            get
            {
                return b_x;
            }
            set
            {
                invalidate(this);

                b_x = value;

                invalidate(this);
            }
            default = 0;
        }


        /**
         * The y coordinate of the insertion point
         */
        public int y
        {
            get
            {
                return b_y;
            }
            set
            {
                invalidate(this);

                b_y = value;

                invalidate(this);
            }
            default = 0;
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
         * Initialize the instance
         */
        construct
        {
            color = Color.TEXT;
            size = 12;
            visibility = Visibility.VISIBLE;
        }


        /**
         * Create a text item
         */
        public TextItem()
        {
            text = "Text";
        }


        /**
         * Create a new text item as an attribute
         *
         * @param x The x coordinate of the insertion point
         * @param y The y coordinate of the insertion point
         * @param name The name of the attribute
         * @param value The value of the attribute
         * @param visibility The visibility of the attribute
         * @param presentation Which portions of the attributes to present
         * @param alignment The alignment of the text
         * @param angle The rottion angle of the text
         * @param color The text color
         * @param size The size of the text
         */
        public TextItem.as_attribute(
            int x,
            int y,
            string name,
            string @value,
            Visibility visibility = Visibility.VISIBLE,
            TextPresentation presentation = TextPresentation.BOTH,
            TextAlignment alignment = TextAlignment.LOWER_LEFT,
            int angle = 0,
            int color = Color.ATTRIBUTE,
            int size = 10
            )

            requires(visibility >= 0)

        {
            this.x = x;
            this.y = y;

            this.alignment = alignment;
            this.angle = angle;
            this.color = color;
            this.size = size;
            this.visibility = visibility;

            // These two function calls must be done in this order to
            // ensure the b_lines field is initialized before calling
            // update_visible_text().

            text = @"$(name)=$(@value)";
            this.presentation = presentation;
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            )
        {
            var bounds = Bounds();

            if ((b_visibility == Visibility.VISIBLE) || reveal)
            {
                bounds = painter.calculate_text_bounds(
                    b_x,
                    b_y,
                    b_alignment,
                    b_angle,
                    b_size,
                    visible_text
                    );
            }

            return bounds;
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
        public override void draw(
            SchematicPainter painter,
            bool reveal,
            bool selected
            )
        {
            if ((b_visibility == Visibility.VISIBLE) || reveal)
            {
                painter.set_cap_type(CapType.NONE);
                painter.set_color(Color.MAJOR_GRID);
                painter.set_dash(DashType.SOLID, 0, 0);
                painter.set_width(10);

                painter.draw_x(b_x, b_y);

                painter.set_color(
                    selected ? Geda3.Color.SELECT : b_color,
                    (b_visibility != Visibility.VISIBLE) && reveal
                    );

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
        public override void mirror_x(int cx)
        {
            invalidate(this);

            b_alignment = b_alignment.mirror_x();
            b_angle = Angle.normalize(-b_angle);
            b_x = 2 * cx - b_x;

            invalidate(this);
        }
        

        /**
         * {@inheritDoc}
         */
        public override void mirror_y(int cy)
        {
            invalidate(this);

            b_alignment = b_alignment.mirror_y();
            b_angle = Angle.normalize(-b_angle);
            b_y = 2 * cy - b_y;

            invalidate(this);
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

            text = string.joinv("\n", b_lines);
        }


        /**
         * {@inheritDoc}
         */
        public override void rotate(int cx, int cy, int angle)
        {
            invalidate(this);

            b_angle = Angle.normalize(b_angle + angle);
            Coord.rotate(cx, cy, angle, ref b_x, ref b_y);

            invalidate(this);
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
            invalidate(this);

            b_x = x;
            b_y = y;

            invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override void translate(int dx, int dy)
        {
            invalidate(this);

            b_x += dx;
            b_y += dy;

            invalidate(this);
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
         */
        private TextAlignment b_alignment;


        /**
         * Backing store for the text angle
         */
        private int b_angle;


        /**
         * Indicates this text represents an attribute
         */
        private bool b_attribute;


        /**
         * Backing store for the color
         */
        private int b_color;


        /**
         * Backing store for text
         */
        private string[] b_lines;


        /**
         * Backing store for the text presentation
         */
        private TextPresentation b_presentation;


        /**
         * Backing store for the text size
         */
        private int b_size;


        /**
         * Backing store for the text visibility
         */
        private Visibility b_visibility;


        /**
         * Backing store the insertion point x coordinate
         */
        private int b_x;


        /**
         * Backing store the insertion point y coordinates
         */
        private int b_y;


        /**
         *
         */
        private void update_visible_text()

            requires (b_lines != null)
            requires (s_attribute_regex != null)

        {
            invalidate(this);

            var local_text = string.joinv("\n", b_lines);

            MatchInfo match_info;

            b_attribute = s_attribute_regex.match(
                local_text,
                0,
                out match_info
                );

            if (b_attribute)
            {
                name = match_info.fetch(1);

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
            }
            else
            {
                name = null;
                visible_text = local_text;
            }

            invalidate(this);
        }
    }
}
