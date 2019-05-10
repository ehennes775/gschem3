namespace Gschem3
{
    /**
     *
     */
    public class AttributeEditing : AttributeState
    {
        /**
         * {@inheritDoc}
         */
        public override string name
        {
            get
            {
                return m_attribute.name;
            }
            set
            {
                var attribute_value = m_attribute.@value;
                return_if_fail(attribute_value != null);

                m_attribute.set_pair(value, attribute_value);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool request_removal
        {
            get
            {
                return false;
            }
        }


        /**
         * {@inheritDoc}
         */
        public override string @value
        {
            get
            {
                return m_attribute.@value;
            }
            set
            {
                var name = m_attribute.name;
                return_if_fail(name != null);

                m_attribute.set_pair(name, value);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool visible
        {
            get
            {
                return
                    m_attribute.visibility == Geda3.Visibility.VISIBLE;
            }
            set
            {
                m_attribute.visibility = value ?
                    Geda3.Visibility.VISIBLE :
                    Geda3.Visibility.INVISIBLE;
            }
        }


        /**
         *
         */
        public AttributeEditing(Geda3.AttributeChild attribute)
        {
            m_attribute = attribute;
        }


        /**
         *
         */
        private Geda3.AttributeChild m_attribute;
    }
}
