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
        }


        /**
         * {@inheritDoc}
         */
        public override void draw_line(int x0, int y0, int x1, int y1)
        {
            cairo_context.move_to(x0, y0);
            cairo_context.line_to(x1, y1);
            cairo_context.stroke();
        }


        /**
         * {@inheritDoc}
         */
        public override void set_cap_type(CapType cap_type)
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
        {
        }
    }
}