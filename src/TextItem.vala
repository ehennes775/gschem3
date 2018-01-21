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
            b_lines = new string[1];
            b_lines[0] = "Text";
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(SchematicPainter painter)
        {
            var bounds = Bounds();

            return bounds;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter)
        {
            if (b_visibility == Visibility.VISIBLE)
            {
                painter.set_cap_type(CapType.NONE);
                painter.set_color(Color.MAJOR_GRID);
                painter.set_dash(DashType.SOLID, 0, 0);
                painter.set_width(10);

                painter.draw_x(b_x, b_y);

                painter.set_color(b_color);

                painter.draw_text(b_x, b_y, b_alignment, b_lines[0]);
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
    }
}
