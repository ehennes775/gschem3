namespace Gschem3
{
    /**
     * An operation to export schematics from the project
     */
    public class ExportNetlist : Object,
        ActionProvider
    {
        /**
         *
         */
        public ProjectSelector? selector
        {
            get
            {
                return b_selector;
            }
            set
            {
                if (b_selector != null)
                {
                    b_selector.notify["project"].disconnect(
                        on_notify_selector
                        );
                }

                b_selector = value;

                if (b_selector != null)
                {
                    b_selector.notify["project"].connect(
                        on_notify_selector
                        );
                }
            }
        }


        /**
         * Initialize the instance
         */
        construct
        {
            m_export_netlist_action.activate.connect(on_activate);

            notify["project"].connect(on_notify_project);
            notify["selector"].connect(on_notify_selector);
        }


        /**
         * Initialize the instance
         *
         * @param parent The parent window for dialog boxes
         */
        public ExportNetlist(
            Gtk.Window? parent,
            ProjectSelector selector
            )
        {
            Object(
                selector : selector
                );

            m_parent = parent;
        }


        /**
         * {@inheritDoc}
         */
        public void add_actions_to(ActionMap map)
        {
            map.add_action(m_export_netlist_action);
        }


        /**
         * The default output filename.
         */
        private const string DEFAULT_NETLIST_FILENAME = "output.net";



        /**
         * The command line application to generate netlists.
         */
        private const string NETLIST_COMMAND = "gnetlist";


        /**
         *
         */
        private ProjectSelector? b_selector = null;


        /**
         *
         */
        private SimpleAction m_export_netlist_action = new SimpleAction(
            "export-netlist",
            null
            );


        /**
         * The transient parent window for dialog boxes
         */
        private Gtk.Window? m_parent;


        /**
         *
         */
        private Geda3.Project? project
        {
            get;
            set;
        }



        /**
         * Perform the operation
         *
         * @param parameter Unused
         */
        private void on_activate(Variant? parameter)
        {
            ExportNetlistDialog dialog = null;

            try
            {
                dialog = create_dialog();

                var result = dialog.run();

                if (result == Gtk.ResponseType.OK)
                {
                    create_netlist_file(
                        dialog.get_filename(),
                        dialog.get_netlist_format()
                        );
                }
            }
            catch (Error error)
            {
            }
            finally
            {
                if (dialog != null)
                {
                    dialog.destroy();
                }
            }
        }


        /**
         * Create the export dialog
         */
        private ExportNetlistDialog create_dialog()
        {
            var dialog = new ExportNetlistDialog();

            dialog.do_overwrite_confirmation = true;
            dialog.set_transient_for(m_parent);

            //dialog.set_current_folder(dirname);
            //dialog.set_current_name(DEFAULT_PRINT_FILENAME);

            return dialog;
        }


        private void on_notify_project(ParamSpec param)
        {
        }


        private void on_notify_selector(ParamSpec param)
        {
            project = null;

            if (selector != null)
            {
                project = selector.project;
            }
        }



        private void create_netlist_file(string filename, string format) throws Error

            requires(project != null)

        {
            var arguments = new Gee.ArrayList<string?>();

            arguments.add(NETLIST_COMMAND);

            arguments.add("-o");
            arguments.add(filename);

            arguments.add("-g");
            arguments.add(format);

            foreach (var item in project.get_files())
            {
                arguments.add(item.file.get_path());
            }

            arguments.add(null);

            /*  Ensure the environment variables OLDPWD and PWD match the
             *  working directory passed into Process.spawn_async(). Some
             *  Scheme scripts use getenv() to determine the current
             *  working directory.
             */

            var environment = new Gee.ArrayList<string?>();

            foreach (string variable in Environment.list_variables())
            {
                if (variable == "OLDPWD")
                {
                    environment.add("%s=%s".printf(variable, Environment.get_current_dir()));
                }
                else if (variable == "PWD")
                {
                    environment.add("%s=%s".printf(variable, project.folder.get_path()));
                }
                else
                {
                    environment.add("%s=%s".printf(variable, Environment.get_variable(variable)));
                }
            }

            environment.add(null);

            int status;

            Process.spawn_sync(
                project.folder.get_path(),
                arguments.to_array(),
                environment.to_array(),
                SpawnFlags.SEARCH_PATH,
                null,
                null,
                null,
                out status
                );

            if (status != 0)
            {
                // throw something
            }
        }
    }
}
