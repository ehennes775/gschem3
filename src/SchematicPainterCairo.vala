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


        public Pango.FontDescription font_description 
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
        public override void draw_text(int x, int y, TextAlignment alignment, int angle, int size, string text)

            requires(cairo_context != null)

        {
            cairo_context.save();

            var layout = Pango.cairo_create_layout(cairo_context);

            Pango.cairo_context_set_resolution(layout.get_context(), 936);

            font_description.set_size(size * Pango.SCALE);
            layout.set_font_description(font_description);
            layout.set_spacing(40000);
            layout.set_markup(text, -1);

            cairo_context.move_to(x, y);
            cairo_context.scale(1.0, -1.0);

            var rotation = Geda3.Angle.to_radians(angle);
            cairo_context.rotate(-rotation);

            var alignment_x = alignment.alignment_x();

            if (alignment_x > 0.0)
            {
                int height;
                int width;
                
                layout.get_size(out width, out height);
                cairo_context.rel_move_to(alignment_x * width / -Pango.SCALE, 0.0);
            }

            var alignment_y = alignment.alignment_y();

            if (alignment_y > 0.0)
            {
                var iter = layout.get_iter();

                while (!iter.at_last_line())
                {
                    iter.next_line();
                }

                cairo_context.rel_move_to(0.0, alignment_y * iter.get_baseline() / -Pango.SCALE);
            }

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
        public override Geda3.Bounds calculate_text_bounds(int x, int y, TextAlignment alignment, int size, string text)
        {
            //var context = new Pango.Context();

            //var layout = new Pango.Layout(context);

            //Pango.cairo_context_set_resolution(layout.get_context(), 936);

            //font_description.set_size(size * Pango.SCALE);
            //layout.set_font_description(font_description);
            //layout.set_spacing(40000);
            //layout.set_markup(text, -1);

            //cairo_context.move_to(x, y);
            //cairo_context.scale(1.0, -1.0);

            //var alignment_x = alignment.alignment_x();

            //if (alignment_x > 0.0)
            //{
            //    int height;
            //    int width;
            //    
            //    layout.get_size(out width, out height);
            //    //cairo_context.rel_move_to(alignment_x * width / -Pango.SCALE, 0.0);
            //}

            //var alignment_y = alignment.alignment_y();

            //if (alignment_y > 0.0)
            //{
            //    var iter = layout.get_iter();

            //    while (!iter.at_last_line())
            //    {
            //        iter.next_line();
            //    }

                //cairo_context.rel_move_to(0.0, alignment_y * iter.get_baseline() / -Pango.SCALE);
            //}

            //Pango.Rectangle ink_extents;
            //Pango.Rectangle logical_extents;

            //layout.get_pixel_extents(out ink_extents, out logical_extents);

            //stdout.printf(@"ink = $(ink_extents.x),$(ink_extents.y),$(ink_extents.width),$(ink_extents.height)");

            //Pango.cairo_show_layout(cairo_context, layout);
            
            //cairo_context.restore();

            Geda3.Bounds bounds = Geda3.Bounds.with_points(x, y, x, y);

            bounds.expand(1000, 1000);

            return bounds;
        }
    }
}
