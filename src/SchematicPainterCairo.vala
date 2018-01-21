namespace Geda3
{
    public class SchematicPainterCairo : SchematicPainter
    {
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


        public SchematicPainterCairo()
        {
            cairo_context = null;
            color_scheme = null;
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
        public override void draw_line(int x0, int y0, int x1, int y1)

            requires(cairo_context != null)

        {
            cairo_context.move_to(x0, y0);
            cairo_context.line_to(x1, y1);
            cairo_context.stroke();
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

    }
}
