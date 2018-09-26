namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/pedit/TextPropertyEditor.ui.xml")]
    public class TextPropertyEditor : Gtk.Expander, ItemEditor
    {
        construct
        {
            expanded = true;                     // not getting set in the XML
            label = "<b>Text Properties</b>";    // not getting set in the XML
            margin_bottom = 8;                   // not getting set in the XML
            margin_top = 8;                      // not getting set in the XML
            use_markup = true;                   // not getting set in the XML
        }


        /**
         *
         *
         * @param items The items to apply a new alignment
         * @param alignment The new alignment to apply
         */
        private static void apply_alignment(Gee.Iterable<Geda3.TextItem> items, Geda3.TextAlignment alignment)
        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.alignment = alignment;
            }
        }


        /**
         *
         *
         * @param items The items to apply a new alignment
         * @param alignment The new alignment to apply
         */
        private static void apply_color(Gee.Iterable<Geda3.TextItem> items, int color)

            requires(color >= Geda3.Color.MIN)
            requires(color <= Geda3.Color.MAX)

        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.color = color;
            }
        }


        /**
         *
         *
         * @param items The items to apply a new rotation
         * @param rotation The new rotation to apply
         */
        private static void apply_rotation(Gee.Iterable<Geda3.TextItem> items, int rotation)
        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.angle = rotation;
            }
        }


        /**
         *
         *
         * @param items The items to apply a new text size
         * @param size The new text size to apply
         */
        private static void apply_size(Gee.Iterable<Geda3.TextItem> items, int size)

            requires(size >= Geda3.TextSize.MIN)
            requires(size <= Geda3.TextSize.MAX)

        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.size = size;
            }
        }
    }
}
