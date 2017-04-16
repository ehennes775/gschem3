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
     * A dialog box to create a new project.
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/NewProjectDialog.xml")]
    public class NewProjectDialog : Gtk.Dialog, Gtk.Buildable

    {
        /**
         * The filename extension for project files
         */
        public const string DEFAULT_PROJECT_NAME = "untitled";


        /**
         * The filename extension for project files
         */
        public const string FILENAME_EXTENSION = ".xml";


        /**
         * A widget showing the project folder already exists.
         *
         * Making this widget visible will indicate to the user that the
         * current project folder already exists.
         */
        [GtkChild(name="hbox-error-folder-exists")]
        private Gtk.Widget m_error_folder_exists;


        /**
         * A widget showing the project folder path is not absolute.
         *
         * Making this widget visible will indicate to the user that the
         * current project folder path is not absolute.
         */
        [GtkChild(name="hbox-error-not-absolute")]
        private Gtk.Widget m_error_not_absolute;


        /**
         * The folder chooser widget containing the parent folder.
         */
        [GtkChild(name="folder-chooser")]
        private Gtk.FileChooserWidget m_folder_chooser;


        /**
         * The entry widget containing the design name.
         */
        [GtkChild(name="name-entry")]
        private Gtk.Entry m_project_name;


        /**
         * Indicates the project name is valid.
         */
        private bool m_project_name_valid;


        /**
         * The entry widget containing the design folder name.
         */
        [GtkChild(name="folder-entry")]
        private Gtk.Entry m_folder_name;


        /**
         * Indicates the folder name is valid.
         *
         * This boolean value is updated after every change to the text
         * inside the folder widget.
         */
        private bool m_folder_name_valid;


        /**
         * Initialize the instance
         */
        construct
        {
            m_folder_chooser.selection_changed.connect(on_selection_change);
            m_folder_name.notify["text"].connect(on_notify_folder);
            m_project_name.notify["text"].connect(on_notify_name);
        }


        /**
         * Create the export netlist dialog.
         */
        public NewProjectDialog()
        {
            /* set up initial values */

            m_folder_chooser.set_filename(
                Environment.get_current_dir()
                );

            m_project_name.text = DEFAULT_PROJECT_NAME;
        }


        /**
         * Gets the project filename
         */
        public string get_project_filename()

            requires(m_folder_chooser != null)
            requires(m_folder_name != null)
            requires(m_project_name != null)
            ensures(result != null)
            ensures(Path.is_absolute(result))

        {
            return GLib.Path.build_filename(
                m_folder_name.text,
                m_project_name.text + FILENAME_EXTENSION,
                null
                );
        }


        /**
         * Handles when the project name changes.
         */
        private void on_notify_folder()

            requires(m_error_folder_exists != null)
            requires(m_error_not_absolute != null)
            requires(m_folder_chooser != null)
            requires(m_folder_name != null)
            requires(m_project_name != null)

        {
            if (m_folder_name.text.length > 0)
            {
                bool folder_exists = FileUtils.test(m_folder_name.text, FileTest.EXISTS);
                m_error_folder_exists.set_visible(folder_exists);

                bool not_absolute = !Path.is_absolute(m_folder_name.text);
                m_error_not_absolute.set_visible(not_absolute);

                m_folder_name_valid = !folder_exists && !not_absolute;
            }
            else
            {
                m_error_folder_exists.set_visible(false);
                m_error_not_absolute.set_visible(false);

                m_folder_name_valid = false;
            }

            update();
        }


        /**
         * Handles when the project name changes.
         */
        private void on_notify_name()

            requires(m_folder_chooser != null)
            requires(m_folder_name != null)
            requires(m_project_name != null)

        {
            m_folder_name.text = GLib.Path.build_filename(
                m_folder_chooser.get_filename(),
                m_project_name.text,
                null
                );

            m_project_name_valid = (m_project_name.text.length > 0);

            update();
        }


        /**
         * Handles when the parent folder changes.
         */
        private void on_selection_change()

            requires(m_folder_chooser != null)
            requires(m_folder_name != null)
            requires(m_project_name != null)

        {
            m_folder_name.text = GLib.Path.build_filename(
                m_folder_chooser.get_filename(),
                m_project_name.text,
                null
                );

            update();
        }


        /**
         * Updates the sensitivity of the ok button.
         */
        private void update()
        {
            set_response_sensitive(
                Gtk.ResponseType.OK,
                m_project_name_valid && m_folder_name_valid
                );
        }
    }
}
