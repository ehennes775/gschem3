/*
 *  Copyright (C) 2012 Edward Hennessy
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
namespace Gschem3
{
    /**
     * A dialog box allowing the user to export a bill of material.
     */
    public class ExportBillOfMaterialDialog : Gtk.FileChooserDialog, Gtk.Buildable
    {
        /**
         * The resource name for the UI design.
         */
        public const string RESOURCE_NAME = "/com/github/ehennes775/gschem3/ExportBillOfMaterialDialog.ui.xml";


        /**
         * The combo box containing the selected BOM format.
         */
        private Gtk.ComboBox m_combo;


        /**
         * The list store containing the BOM formats.
         */
        private Gtk.ListStore m_formats;


        /**
         * Initialize the class.
         */
        class construct
        {
            set_template_from_resource(RESOURCE_NAME);
        }


        /**
         * Create the export netlist dialog.
         */
        public ExportBillOfMaterialDialog()
        {
            init_template();
        }


        /**
         * Gets the name of the BOM format
         */
        public string? get_bom_format()

            requires(m_combo != null)
            requires(m_formats != null)

        {
            Gtk.TreeIter iter;

            if (m_combo.get_active_iter(out iter))
            {
                GLib.Value value;

                m_formats.get_value(iter, 0, out value);

                return value.get_string();
            }

            return null;
        }


        /**
         * Couldn't get the template bindings to work, so this function
         * obtains the objects from the Gtk.Builder.
         */
        private void parser_finished(Gtk.Builder builder)
        {
            m_combo = builder.get_object("format-combo") as Gtk.ComboBox;
            m_formats = builder.get_object("bom-formats") as Gtk.ListStore;
        }
    }
}
