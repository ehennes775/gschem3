namespace Gschem3
{
    /**
     * Operations to export netlists from the project
     */
    public class ExportNetlist : Object,
        ActionProvider
    {
        /**
         * Provides the current project
         */
        public ProjectSelector? selector
        {
            get
            {
                return b_selector;
            }
            construct set
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
            default = null;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            m_export_netlist_action.activate.connect(on_activate);

            notify["selector"].connect(on_notify_selector);
        }


        /**
         * Initialize the instance
         *
         * @param parent The parent window for dialog boxes
         * @param selector Provides the current project
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
         * The default output filename
         */
        private const string DEFAULT_NETLIST_FILENAME = "output.net";



        /**
         * The command line application to generate netlists
         */
        private const string NETLIST_COMMAND = "lepton-netlist";


        /**
         * Backing store for the project selector
         */
        private ProjectSelector? b_selector = null;


        /**
         * Action for exporting a netlist
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
         * The current project
         */
        private Geda3.Project? m_project = null;



        /**
         * Perform the operation
         *
         * @param parameter Unused
         */
        private void on_activate(Variant? parameter)

            requires(m_project != null)

        {
            ExportNetlistDialog dialog = null;

            try
            {
                dialog = create_dialog();

                var result = dialog.run();

                if (result == Gtk.ResponseType.OK)
                {
                    var format = dialog.get_netlist_format();

                    create_netlist_file(
                        dialog.get_filename(),
                        format
                        );

                    m_project.store_netlist_export_format(format);
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

            var format = "PCB";
            m_project.retrieve_netlist_export_format(ref format);
                
            dialog.set_netlist_format(format);

            var folder = Path.build_filename(
                m_project.folder.get_path(),
                "net"
                );

            dialog.set_current_folder(folder);
            dialog.set_current_name(DEFAULT_NETLIST_FILENAME);

            return dialog;
        }


        /**
         * Signal handler for updating the curremt project
         */
        private void on_notify_selector(ParamSpec param)
        {
            m_project = null;

            if (selector != null)
            {
                m_project = selector.project;
            }

            var enabled = m_project != null;
            m_export_netlist_action.set_enabled(enabled);
        }



        /**
         * Creates the netlist file
         *
         * Both parameters follow the lepton-netlist command line
         * arguments.
         *
         * @param filename The output filename for the netlist
         * @param format The format to use for the netlist
         */
        private void create_netlist_file(
            string filename,
            string format
            )
            throws Error

            requires(m_project != null)
            requires(m_project.folder != null)
            requires(m_project.folder.get_path() != null)

        {
            var arguments = new Gee.ArrayList<string?>();

            arguments.add(NETLIST_COMMAND);

            arguments.add("-o");
            arguments.add(filename);

            arguments.add("-g");
            arguments.add(format);

            foreach (var item in m_project.get_files())
            {
                arguments.add(item.file.get_path());
            }

            arguments.add(null);

            /* Ensure the environment variables OLDPWD and PWD match the
             * working directory passed into Process.spawn_async(). Some
             * Scheme scripts use getenv() to determine the current
             * working directory.
             */

            var environment = new Gee.ArrayList<string?>();

            foreach (string variable in Environment.list_variables())
            {
                if (variable == "OLDPWD")
                {
                    environment.add("%s=%s".printf(
                        variable,
                        Environment.get_current_dir()
                        ));
                }
                else if (variable == "PWD")
                {
                    environment.add("%s=%s".printf(
                        variable,
                        m_project.folder.get_path()
                        ));
                }
                else
                {
                    environment.add("%s=%s".printf(
                        variable,
                        Environment.get_variable(variable)
                        ));
                }
            }

            environment.add(null);

            int status;

            Process.spawn_sync(
                m_project.folder.get_path(),
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
