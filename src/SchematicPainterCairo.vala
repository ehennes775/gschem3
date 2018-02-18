namespace Geda3
{
    public class SchematicPainterCairo : SchematicPainter
    {
        /**
         * The size to use for grips
         *
         * The width and height of the grips, divided by 2, in pixels.
         */
        public const int GRIP_HALF_WIDTH = 5;


        public Cairo.Context cairo_context
        {
            get;
            set;
        }


        public ColorScheme color_scheme
        {
            get;
            set;
        }


        public Pango.FontDescription font_description 
        {
            get;
            set;
        }


        public Cairo.Matrix matrix0
        {
            get;
            set;
        }


        public Cairo.Matrix matrix1
        {
            get;
            set;
        }


        public Pango.Context pango_context
        {
            get;
            set;
        }


        public SchematicPainterCairo()
        {
            cairo_context = null;
            color_scheme = null;
            font_description = Pango.FontDescription.from_string("Sans");
        }


        /**
         * {@inheritDoc}
         */
        public override void draw_box(int x0, int y0, int x1, int y1)

            requires(cairo_context != null)

        {
            cairo_context.move_to(x0, y0);
            cairo_context.line_to(x1, y0);
            cairo_context.line_to(x1, y1);
            cairo_context.line_to(x0, y1);
            cairo_context.close_path();
            cairo_context.stroke();
        }


        /**
         * {@inheritDoc}
         */
        public override void draw_circle(int center_x, int center_y, int radius)

            requires(cairo_context != null)

        {
            cairo_context.move_to(center_x + radius, center_y);
            cairo_context.arc(center_x, center_y, radius, 0.0, 2.0 * Math.PI);
            cairo_context.stroke();
        }


        /**
         * {@inheritDoc}
         */
        public override void draw_grip(int center_x, int center_y)

            requires(cairo_context != null)

        {
            cairo_context.save();

            cairo_context.set_matrix(matrix0);

            double x = center_x;
            double y = center_y;

            matrix1.transform_point(ref x, ref y);

            x = Math.round(x);
            y = Math.round(y);

            cairo_context.move_to(x - GRIP_HALF_WIDTH, y - GRIP_HALF_WIDTH);
            cairo_context.line_to(x + GRIP_HALF_WIDTH, y - GRIP_HALF_WIDTH);
            cairo_context.line_to(x + GRIP_HALF_WIDTH, y + GRIP_HALF_WIDTH);
            cairo_context.line_to(x - GRIP_HALF_WIDTH, y + GRIP_HALF_WIDTH);
            cairo_context.close_path();

            var rgba = color_scheme[Color.SELECT];

            cairo_context.set_source_rgba(
                0.125 * rgba.red,
                0.125 * rgba.green,
                0.125 * rgba.blue,
                rgba.alpha
                );

            cairo_context.fill_preserve();

            cairo_context.set_source_rgba(
                rgba.red,
                rgba.green,
                rgba.blue,
                rgba.alpha
                );

            cairo_context.set_line_width(1.0);

            cairo_context.stroke();

            cairo_context.restore();
        }


        /**
         * {@inheritDoc}
         */
        public override void draw_line(int x0, int y0, int x1, int y1)

            requires(cairo_context != null)

        {
            cairo_context.move_to(x0, y0);
            cairo_context.line_to(x1, y1);
            cairo_context.stroke();
        }


        /**
         * Draw the box used to select items
         *
         * @param x0 The x coordinate of the first corner in device units
         * @param y0 The y coordinate of the first corner in device units
         * @param x1 The x coordinate of the second corner in device units
         * @param y1 The y coordinate of the second corner in device units
         */
        public void draw_select_box(int x0, int y0, int x1, int y1)

            requires(cairo_context != null)

        {
            draw_bounding_box(x0, y0, x1, y1, Geda3.Color.BOUNDING_BOX);
        }


        /**
         * {@inheritDoc}
         */
        public override void draw_text(
            int x,
            int y,
            TextAlignment alignment,
            int angle,
            int size,
            string text
            )

            requires(cairo_context != null)
            requires(pango_context != null)

        {
            cairo_context.save();

            var layout = new Pango.Layout(pango_context);

            font_description.set_size(size * Pango.SCALE);
            layout.set_font_description(font_description);
            layout.set_spacing(40000);
            layout.set_markup(text, -1);

            cairo_context.move_to(x, y);
            cairo_context.scale(1.0, -1.0);

            var rotation = Geda3.Angle.to_radians(angle);
            cairo_context.rotate(-rotation);

            int dx = 0;
            int dy = 0;

            calculate_text_adjustment(layout, alignment, size, out dx, out dy);

            cairo_context.rel_move_to(
                (double) dx / (double) Pango.SCALE,
                (double) dy / (double) Pango.SCALE
                );

            Pango.cairo_show_layout(cairo_context, layout);

            cairo_context.restore();
        }


        /**
         * {@inheritDoc}
         */
        public override void draw_x(int x, int y)

            requires(cairo_context != null)

        {
            cairo_context.move_to(x - 20, y - 20);
            cairo_context.line_to(x + 20, y + 20);
            cairo_context.move_to(x - 20, y + 20);
            cairo_context.line_to(x + 20, y - 20);
            cairo_context.stroke();
        }


        /**
         * Draw the box used to select items
         *
         * @param x0 The x coordinate of the first corner in device units
         * @param y0 The y coordinate of the first corner in device units
         * @param x1 The x coordinate of the second corner in device units
         * @param y1 The y coordinate of the second corner in device units
         */
        public void draw_zoom_box(int x0, int y0, int x1, int y1)

            requires(cairo_context != null)

        {
            draw_bounding_box(x0, y0, x1, y1, Geda3.Color.ZOOM_BOX);
        }


        /**
         * {@inheritDoc}
         */
        public override void set_cap_type(CapType cap_type)

            requires(cap_type >= 0)
            requires(cap_type < CapType.COUNT)
            requires(cairo_context != null)

        {
            switch (cap_type)
            {
                case CapType.SQUARE:
                    cairo_context.set_line_cap(Cairo.LineCap.SQUARE);
                    break;

                case CapType.ROUND:
                    cairo_context.set_line_cap(Cairo.LineCap.ROUND);
                    break;

                case CapType.NONE:
                default:
                    cairo_context.set_line_cap(Cairo.LineCap.BUTT);
                    break;
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void set_color(int index)

            requires(cairo_context != null)
            requires(color_scheme != null)
            requires(index >= 0)

        {
            var rgba = color_scheme[index];

            cairo_context.set_source_rgba(
                rgba.red,
                rgba.green,
                rgba.blue,
                rgba.alpha
                );
        }


        /**
         * {@inheritDoc}
         */
        public override void set_dash(DashType dash_type, int length, int space)

            requires(cairo_context != null)
            requires(dash_type >= 0)
            requires(dash_type < DashType.COUNT)
            requires(length >= 0)
            requires(space >= 0)

        {
        }


        /**
         * {@inheritDoc}
         */
        public override void set_width(int width)

            requires(cairo_context != null)
            requires(width >= 0)

        {
            cairo_context.set_line_width(width);
        }


        /**
         * {@inheritDoc}
         */
        public override Geda3.Bounds calculate_text_bounds(
            int x,
            int y,
            TextAlignment alignment,
            int size,
            string text
            )

            requires(pango_context != null)

        {
            var layout = new Pango.Layout(pango_context);

            font_description.set_size(size * Pango.SCALE);
            layout.set_font_description(font_description);
            layout.set_spacing(40000);
            layout.set_markup(text, -1);

            var matrix = Cairo.Matrix.identity();

            matrix.scale(1.0 / Pango.SCALE, -1.0 / Pango.SCALE);

            int dx = 0;
            int dy = 0;

            calculate_text_adjustment(layout, alignment, size, out dx, out dy);
            matrix.translate(dx, dy);

            Pango.Rectangle ink = { 0 };
            Pango.Rectangle logical = { 0 };

            layout.get_extents(out ink, out logical);

            double x0 = ink.x;
            double y0 = ink.y;
            double x1 = ink.x + ink.width;
            double y1 = ink.y + ink.height;

            matrix.transform_point(ref x0, ref y0);
            matrix.transform_point(ref x1, ref y1);

            var bounds = Bounds.with_fpoints(x0, y0, x1, y1);

            //bounds.rotate();
            bounds.translate(x, y);

            // add the bounds of the insertion point graphic "x"

            var bounds_x = Bounds.with_points(
                x - 20,
                y - 20,
                x + 20,
                y + 20
                );

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * 10);

            bounds_x.expand(expand, expand);

            bounds.union(bounds_x);

            return bounds;
        }


        /**
         *
         * @return The cap height in Pango units
         */
        private int calculate_cap_height(int size)

            requires(pango_context != null)
            ensures(result >= 0)

        {
            var layout = new Pango.Layout(pango_context);

            font_description.set_size(size * Pango.SCALE);
            layout.set_font_description(font_description);
            layout.set_spacing(40000);
            layout.set_markup("O", -1);

            var iter = layout.get_iter();
            
            Pango.Rectangle ink = { 0 };
            Pango.Rectangle logical = { 0 };

            int baseline = iter.get_baseline();
            iter.get_layout_extents(out ink, out logical);

            return ink.y - baseline;
        }


        /**
         *
         * This function uses the logical y for the top of the layout
         * and needs to be changed to top of a capital letter when the
         * cap height becomes available.
         *
         * @param layout
         * @param alignment
         * @param size
         * @param dx The x offset in Pango units
         * @param dy The y offset in Pango units
         */
        private static void calculate_text_adjustment(
            Pango.Layout layout,
            Geda3.TextAlignment alignment,
            int size,
            out int dx,
            out int dy
            )
        {

            dx = 0;

            var alignment_x = alignment.alignment_x();

            if (alignment_x > 0.0)
            {
                int height;
                int width;
                
                layout.get_size(out width, out height);

                dx = - (int) Math.round(alignment_x * width);
            }

            dy = 0;

            var alignment_y = alignment.alignment_y();

            if (alignment_y > 0.0)
            {
                var iter = layout.get_iter();

                while (!iter.at_last_line())
                {
                    iter.next_line();
                }

                dy = - (int) Math.round(alignment_y * iter.get_baseline());
            }
        }


        /**
         * Draw the box used to select items
         *
         * @param x0 The x coordinate of the first corner in device units
         * @param y0 The y coordinate of the first corner in device units
         * @param x1 The x coordinate of the second corner in device units
         * @param y1 The y coordinate of the second corner in device units
         * @param color The color index to use for drawing the box
         */
        private void draw_bounding_box(int x0, int y0, int x1, int y1, int color)

            requires(cairo_context != null)

        {
            cairo_context.save();

            cairo_context.set_matrix(matrix0);

            set_cap_type(CapType.NONE);
            set_dash(DashType.SOLID, 0, 0);
            cairo_context.set_line_width(1.0);

            cairo_context.move_to(x0, y0);
            cairo_context.line_to(x1, y0);
            cairo_context.line_to(x1, y1);
            cairo_context.line_to(x0, y1);
            cairo_context.close_path();

            var rgba = color_scheme[color];

            cairo_context.set_source_rgba(
                rgba.red,
                rgba.green,
                rgba.blue,
                0.125 * rgba.alpha
                );

            cairo_context.fill_preserve();

            cairo_context.set_source_rgba(
                rgba.red,
                rgba.green,
                rgba.blue,
                rgba.alpha
                );

            cairo_context.stroke();

            cairo_context.restore();
        }
    }
}
