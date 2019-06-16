namespace Gschem3
{
    /**
     *
     */
    public class SchematicSupport : Object,
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
            promoter = new Geda3.StandardPromoter();

            notify["selector"].connect(on_notify_selector);
        }


        /**
         * Initialize the instance
         */
        public SchematicSupport(MainWindow window)
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
            return_if_fail(window.document_notebook != null);
            return_if_fail(window.document_opener != null);
            return_if_fail(window.drawing_tools != null);

            m_opener = new SchematicWindowOpener(
                window.document_notebook,
                window.drawing_tools
                );

            window.document_opener.add_opener(m_opener);
        }


        /**
         * {@inheritDoc}
         */
        public void deactivate()
        {
            var window = object as MainWindow;

            return_if_fail(window != null);
            return_if_fail(window.document_opener != null);

            window.document_opener.remove_opener(m_opener);
            m_opener = null;
        }


        /**
         * {@inheritDoc}
         */
        public void update_state()
        {
        }


        /**
         * The backing store for the attribute promoter
         */
        private Geda3.AttributePromoter b_promoter;


        /**
         * The current project selector
         */
        private ProjectSelector? b_selector = null;


        /**
         * The current project
         */
        private Geda3.Project? m_project = null;


        /**
         * Provides functionality to open schematic documents
         */
        private SchematicWindowOpener? m_opener = null;


        /**
         * Provides attribute promotion
         */
        public Geda3.AttributePromoter promoter
        {
            get
            {
                return b_promoter;
            }
            private set
            {
                b_promoter = value;

                b_promoter.configuration = m_project;
            }
        }


        /**
         * Signal handler for updating the curremt project
         */
        private void on_notify_selector(ParamSpec param)

            requires(b_promoter != null)

        {
            m_project = null;

            if (selector != null)
            {
                m_project = selector.project;
            }

            b_promoter.configuration = m_project;
        }
    }
}
