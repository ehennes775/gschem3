namespace Gschem3
{
    /**
     *
     */
    public class AttributeCreating : AttributeState
    {
        /**
         * {@inheritDoc}
         */
        public override string name
        {
            get
            {
                return m_name;
            }
            set
            {
                return_if_fail(!request_removal);

                m_name = value;

                m_name_set = true;

                name_valid = validate_name(m_name);
            }
            default = UNSET;
        }


        /**
         * {@inheritDoc}
         */
        public override Geda3.TextPresentation presentation
        {
            get;
            set;
        }


        /**
         * {@inheritDoc}
         */
        public override bool request_removal
        {
            get
            {
                return m_name_set && m_value_set;
            }
        }


        /**
         * {@inheritDoc}
         */
        public override string @value
        {
            get
            {
                return m_value;
            }
            set
            {
                return_if_fail(!request_removal);

                m_value = value;

                m_value_set = true;
                
                value_valid = validate_value(m_value);
            }
            default = UNSET;
        }


        /**
         * {@inheritDoc}
         */
        public override bool visible
        {
            get;
            set;
            default = true;
        }


        /**
         *
         */
        public AttributeCreating(Geda3.AttributeCreator item)
        {
            m_item = item;

            m_name_set = false;
            m_value_set = false;
        }



        /**
         *
         */
        public Geda3.AttributeChild create_and_attach()

            requires(m_item != null)
            requires(m_item.can_create_and_attach)

        {
            return m_item.create_and_attach(
                m_name,
                m_value,
                presentation,
                Geda3.Visibility.from_boolean(visible)
                );
        }


        /**
         *
         */
        private const string UNSET = "";


        /**
         *
         */
        private Geda3.AttributeCreator m_item;


        /**
         *
         */
        private string m_name;


        /**
         *
         */
        private bool m_name_set;


        /**
         *
         */
        private string m_value;


        /**
         *
         */
        private bool m_value_set;
    }
}
