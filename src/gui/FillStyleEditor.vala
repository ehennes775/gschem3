namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/FillStyleEditor.ui.xml")]
    public class FillStyleEditor : Gtk.Expander, ItemEditor
    {
        construct
        {
            expanded = true;         // not getting set in the XML
            label = "Fill Style";    // not getting set in the XML
        }
    }
}
