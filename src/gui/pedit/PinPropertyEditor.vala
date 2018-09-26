namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/pedit/PinPropertyEditor.ui.xml")]
    public class PinPropertyEditor : Gtk.Expander, ItemEditor
    {
        construct
        {
            expanded = true;                    // not getting set in the XML
            label = "<b>Pin Properties</b>";    // not getting set in the XML
            margin_bottom = 8;                  // not getting set in the XML
            margin_top = 8;                     // not getting set in the XML
            use_markup = true;                  // not getting set in the XML
        }
    }
}
