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
                m_name = value;

                m_name_set = true;
            }
            default = UNSET;
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
                m_value = value;

                m_value_set = true;
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
        public AttributeCreating(Geda3.AttributeParent item)
        {
            m_item = item;

            m_name_set = false;
            m_value_set = false;
        }


        /**
         *
         */
        private const string UNSET = "";


        /**
         *
         */
        private Geda3.AttributeParent m_item;


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
