namespace Geda3
{
    /**
     * Adapts the project as an item in the project tree
     */
    public class ProjectItemAdapter : ProjectItem
    {
        /**
         * The project adapted as an item
         */
        public Project? project
        {
            get
            {
                return b_project;
            }
            set
            {
                if (b_project != null)
                {
                    b_project.notify["file"].disconnect(
                        on_notify_project_file
                        );
                }

                b_project = value;

                if (b_project != null)
                {
                    b_project.notify["file"].connect(
                        on_notify_project_file
                        );
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public override string tab
        {
            get;
            protected set;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            notify["project"].connect(on_notify_project_file);
        }


        /**
         * Initialize a new instance with a project
         *
         * @param project The project to be adapted as an item
         */
        public ProjectItemAdapter(Project project)
        {
            this.project = project;
        }


        /**
         * Backing store for the project property
         */
        private Project b_project;


        /**
         * Signal handler when the project or project file changes
         *
         * Two propery notifications are connected to this signal
         * handler. When the project property of this object changes,
         * or the file property of the project object, this handler
         * keeps the tab up to date.
         * 
         * @param param unused
         */
        private void on_notify_project_file(ParamSpec param)
        {
            if ((b_project != null) && (b_project.file != null))
            {
                var file_info = b_project.file.query_info(
                    FileAttribute.STANDARD_DISPLAY_NAME,
                    FileQueryInfoFlags.NONE
                    );

                tab = file_info.get_display_name();
            }
            else
            {
                tab = "Unknown";
            }
        }
    }
}
