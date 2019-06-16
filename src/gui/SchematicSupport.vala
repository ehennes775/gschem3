namespace Gschem3
{
    /**
     *
     */
    public class SchematicSupport : Object
    {
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
