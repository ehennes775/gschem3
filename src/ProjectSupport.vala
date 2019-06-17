namespace Gschem3
{
    /**
     *
     */
    public class ProjectSupport : Object,
        Peas.Activatable
    {
        /**
         * A reference to the main window
         */
        public Object object
        {
            owned get;
            construct;
        }


        /**
         * The currently open project
         * 
         * If this field contains null, then no project is currently open
         */
        public Geda3.Project? project
        {
            get;
            private set;
        }



        /**
         * Initialize the instance
         */
        construct
        {
            m_create_project_action.activate.connect(
                on_create_project
                );

            m_open_project_action.activate.connect(
                on_open_project
                );

            m_save_project_action.activate.connect(
                on_save_project
                );
        }


        /**
         * Initialize the instance
         */
        public ProjectSupport(MainWindow window)
        {
            Object(
                object : window
                );
        }


        /**
         * {@inheritDoc}
         */
        public void activate()
        {
            var window = object as MainWindow;

            return_if_fail(window != null);

            m_project_widget = new ProjectWidget();
            m_project_widget.opener = window.document_opener;

            window.side_stack.add_titled(
                m_project_widget,
                "project",
                "Project"
                );

            bind_property(
                "project",
                m_project_widget,
                "project",
                BindingFlags.SYNC_CREATE
                );

            window.add_action(m_create_project_action);
            window.add_action(m_open_project_action);
            window.add_action(m_save_project_action);
        }


        /**
         * Close the current project
         *
         * Truth table for this function:
         *
         * project = the state of the project on entry
         * changed = changes made to project since last save
         * abort = user chose not to save the changes
         * dialog = the user response from the dialog
         * save = if the project is saved
         * output = the state of the project on exit
         *
         * |project|changed|dialog |save |output|
         * +-------+-------+-------+-----+------+
         * |closed |x      |x      |false|closed|
         * |open   |false  |x      |false|closed|
         * |open   |true   |save   |true |closed|
         * |open   |true   |discard|false|closed|
         * |open   |true   |cancel |false|open  |
         *
         * If the project is open after this function is called, then
         * operations such as project-new and project-open should
         * abort.
         */
        public void close_project()
        {
            if (project != null)
            {
                if (false) // if (project.changed)
                {
                    var dialog = new Gtk.MessageDialog(
                        object as Gtk.Window,
                        Gtk.DialogFlags.MODAL,
                        Gtk.MessageType.QUESTION,
                        Gtk.ButtonsType.NONE,
                        "Save changes?"
                        );

                    dialog.add_buttons(
                        "Save",    Gtk.ResponseType.YES,
                        "Discard", Gtk.ResponseType.NO,
                        "Cancel",  Gtk.ResponseType.CANCEL
                        );

                    var response = dialog.run();

                    if (response == Gtk.ResponseType.YES)
                    {
                        try
                        {
                            project.save();
                            project = null;
                        }
                        catch (Error error)
                        {
                            ErrorDialog.show_with_file(
                                object as Gtk.Window,
                                error,
                                project.file
                                );
                        }
                    }
                    else if (response == Gtk.ResponseType.NO)
                    {
                        project = null;
                    }

                    dialog.destroy();
                }
                else
                {
                    project = null;
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public void deactivate()
        {
            var window = object as MainWindow;

            return_if_fail(window != null);

            window.remove_action(m_create_project_action.name);
            window.remove_action(m_open_project_action.name);
            window.remove_action(m_save_project_action.name);

            m_project_widget.destroy();
            m_project_widget = null;
        }


        /**
         * Open an existing project
         *
         * @param file the project file to open
         */
        public void open_project_with_file(File file) throws Error
        {
            close_project();

            if (project == null)
            {
                var mapper = new Geda3.KeyFileProjectStorage.open(file);

                project = new Geda3.Project(mapper);
            }
        }


        /**
         * {@inheritDoc}
         */
        public void update_state()
        {
        }


        /**
         * The file extension for projects
         */
        private const string PROJECT_EXTENSION = ".project";


        /**
         * File filters used by the open project dialog
         */
        private static Gtk.FileFilter[] s_project_filters = create_project_filters();


        /**
         * The widget containing the project view
         */
        private ProjectWidget m_project_widget;


        /**
         *
         */
        private SimpleAction m_create_project_action = new SimpleAction(
            "project-new",
            null
            );


        /**
         *
         */
        private SimpleAction m_open_project_action = new SimpleAction(
            "project-open",
            null
            );


        /**
         *
         */
        private SimpleAction m_save_project_action = new SimpleAction(
            "project-save",
            null
            );


        /**
         * Create the file filters used by the open project
         */
        private static Gtk.FileFilter[] create_project_filters()
        {
            var filters = new Gee.ArrayList<Gtk.FileFilter>();

            var all = new Gtk.FileFilter();
            all.set_filter_name("All Files");
            all.add_pattern("*.*");
            filters.add(all);

            var projects = new Gtk.FileFilter();
            projects.set_filter_name("Projects");
            projects.add_pattern(@"*$PROJECT_EXTENSION");
            filters.add(projects);

            return filters.to_array();
        }


        /**
         * Create a new project and set it as the current project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_create_project(SimpleAction action, Variant? parameter)
        {
            close_project();

            if (project == null)
            {
                var dialog = new NewProjectDialog();

                dialog.set_transient_for(object as Gtk.Window);

                var response = dialog.run();

                if (response == Gtk.ResponseType.ACCEPT)
                {
                    //var file = dialog.get_file();

                    //project = new Geda3.KeyFileProject.create(file);
                }

                dialog.destroy();
            }
        }


        /**
         * Open an existing project and set it as the current project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_open_project(SimpleAction action, Variant? parameter)
        {
            close_project();

            if (project == null)
            {
                var dialog = new Gtk.FileChooserDialog(
                    "Select File",
                    object as Gtk.Window,
                    Gtk.FileChooserAction.OPEN,
                    "_Cancel", Gtk.ResponseType.CANCEL,
                    "_Open", Gtk.ResponseType.ACCEPT
                    );

                foreach (var filter in s_project_filters)
                {
                    dialog.add_filter(filter);
                }

                var response = dialog.run();

                if (response == Gtk.ResponseType.ACCEPT)
                {
                    var file = dialog.get_file();

                    open_project_with_file(file);
                }

                dialog.destroy();
            }
        }


        /**
         * Save the current project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_save_project(SimpleAction action, Variant? parameter)

            requires(project != null)

        {
            project.save();
        }
    }
}
