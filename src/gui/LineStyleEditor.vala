namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/LineStyleEditor.ui.xml")]
    public class LineStyleEditor : Gtk.Expander, ItemEditor
    {
        construct
        {
            expanded = true;         // not getting set in the XML
            label = "Line Style";    // not getting set in the XML
        }
    }
}
