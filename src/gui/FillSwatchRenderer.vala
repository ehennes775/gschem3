namespace Gschem3
{
    /**
     *
     */
    public class FillSwatchRenderer : Gtk.CellRendererText
    {
        /**
         *
         */
        public bool enabled
        {
            get;
            construct set;
            default = true;
        }


        /**
         *
         */
        public Geda3.FillType fill_type
        {
            get;
            construct set;
            default = Geda3.FillType.HOLLOW;
        }


        /**
         *
         */
        public override void render(
            Cairo.Context context,
            Gtk.Widget widget,
            Gdk.Rectangle background_area,
            Gdk.Rectangle cell_area,
            Gtk.CellRendererState flags
            )
        {
            var state = widget.get_state_flags();
            
            var style_context = widget.get_style_context();

            var text_color = style_context.get_color(
                state
                );

            context.set_source_rgba(
                text_color.red,
                text_color.green,
                text_color.blue,
                text_color.alpha
                );

            context.set_line_width(2);

            var offset = 1.0;

            context.move_to(
               (double) cell_area.x + offset,
               (double) cell_area.y + offset
               );

            context.line_to(
               (double) cell_area.x + (double) cell_area.width - offset,
               (double) cell_area.y + offset
               );

            context.line_to(
               (double) cell_area.x + (double) cell_area.width - offset,
               (double) cell_area.y + (double) cell_area.height - offset
               );

            context.line_to(
               (double) cell_area.x + offset,
               (double) cell_area.y + (double) cell_area.height - offset
               );

            context.close_path();

            if (fill_type == Geda3.FillType.FILL)
            {
                context.fill_preserve();
                context.stroke();
            }
            else if (fill_type.uses_first_set())
            {
                context.stroke();

                context.save();

                context.translate(
                    (cell_area.x + cell_area.width) / 2.0,
                    (cell_area.y + cell_area.height) / 2.0
                    );

                context.rotate(Geda3.Angle.to_radians(45));

                context.move_to(-100.0, 0.0);
                context.line_to(100.0, 0.0);

                context.move_to(-100.0, 7.0);
                context.line_to(100.0, 7.0);

                context.move_to(-100.0, -7.0);
                context.line_to(100.0, -7.0);

                    context.move_to(-100.0, 14.0);
                    context.line_to(100.0, 14.0);

                    context.move_to(-100.0, -14.0);
                    context.line_to(100.0, -14.0);

                context.stroke();
                context.restore();

                if (fill_type.uses_second_set())
                {
                    context.save();
                    context.translate(
                        (cell_area.x + cell_area.width) / 2.0,
                        (cell_area.y + cell_area.height) / 2.0
                        );

                    context.rotate(Geda3.Angle.to_radians(135));

                    context.move_to(-100.0, 0.0);
                    context.line_to(100.0, 0.0);

                    context.move_to(-100.0, 7.0);
                    context.line_to(100.0, 7.0);

                    context.move_to(-100.0, -7.0);
                    context.line_to(100.0, -7.0);

                    context.move_to(-100.0, 14.0);
                    context.line_to(100.0, 14.0);

                    context.move_to(-100.0, -14.0);
                    context.line_to(100.0, -14.0);

                    context.stroke();
                    context.restore();
                }
            }
            else
            {
                context.stroke();
            }
        }
    }
}
