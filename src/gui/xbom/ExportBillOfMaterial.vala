namespace Gschem3
{
    /**
     * An operation to export a bill of material from the project
     */
    public class ExportBillOfMaterial : Object,
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
            m_export_bom.activate.connect(on_activate);

            notify["selector"].connect(on_notify_selector);
        }


        /**
         * Initialize the instance
         *
         * @param parent The parent window for dialog boxes
         * @param selector Provides the current project
         */
        public ExportBillOfMaterial(
            Gtk.Window? parent,
            ProjectSelector? selector
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
            map.add_action(m_export_bom);
        }


        /**
         * The default output filename
         */
        private const string DEFAULT_BOM_FILENAME = "output.bom";


        /**
         * The command line application to generate bills of material
         */
        private const string NETLIST_COMMAND = "lepton-netlist";


        /**
         * Backing store for the project selector
         */
        private ProjectSelector? b_selector = null;


        /**
         *
         */
        private SimpleAction m_export_bom = new SimpleAction(
            "export-bill-of-material",
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
        public void on_activate(Variant? parameter)
        {
            ExportBillOfMaterialDialog dialog = null;

            try
            {
                dialog = create_dialog();

                var result = dialog.run();

                if (result == Gtk.ResponseType.OK)
                {
                    create_bom_file(
                        dialog.get_filename(),
                        dialog.get_bom_format()
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
        private ExportBillOfMaterialDialog create_dialog()
        {
            var dialog = new ExportBillOfMaterialDialog();

            dialog.do_overwrite_confirmation = true;
            dialog.set_transient_for(m_parent);

            //dialog.set_current_folder(dirname);
            //dialog.set_current_name(DEFAULT_PRINT_FILENAME);

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
            m_export_bom.set_enabled(enabled);
        }



        /**
         * Creates the boll of material file
         *
         * Both parameters follow the lepton-netlist command line
         * arguments.
         *
         * @param filename The output filename for the bom
         * @param format The format to use for the bom
         */
        private void create_bom_file(
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
