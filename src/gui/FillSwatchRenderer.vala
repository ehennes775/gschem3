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
            var style_context = widget.get_style_context();

            Gdk.RGBA text_color;

            var success = style_context.lookup_color(
                "text_color",
                out text_color
                );

            warn_if_fail(success);

            context.set_source_rgba(
                text_color.red,
                text_color.green,
                text_color.blue,
                text_color.alpha
                );

            var offset = 1.0;

            context.move_to(
               (double) cell_area.x + offset,
               (double) cell_area.y + offset);

            context.line_to(
               (double) cell_area.x + (double) cell_area.width - offset,
               (double) cell_area.y + offset);

            context.line_to(
               (double) cell_area.x + (double) cell_area.width - offset,
               (double) cell_area.y + (double) cell_area.height - offset);

            context.line_to(
               (double) cell_area.x + offset,
               (double) cell_area.y + (double) cell_area.height - offset);

            context.close_path();

            context.set_line_width(2);
            context.stroke();
        }
    }
}
