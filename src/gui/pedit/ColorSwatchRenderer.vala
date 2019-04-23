namespace Gschem3
{
    /**
     *
     */
    public class ColorSwatchRenderer : Gtk.CellRendererText
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
        public Gdk.RGBA color
        {
            get;
            set;

            // construct set; -- generates SIGSEGV
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

            context.set_source_rgba(
                color.red,
                color.green,
                color.blue,
                color.alpha
                );

            context.fill_preserve();

            context.set_source_rgba(
                text_color.red,
                text_color.green,
                text_color.blue,
                text_color.alpha
                );

            context.stroke();
        }
    }
}
