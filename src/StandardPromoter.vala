namespace Geda3
{
    /**
     *
     */
    public class StandardPromoter : AttributePromoter
    {
        /**
         * The configuration for attribute promotion
         */
        public override StandardPromoterConfiguration? configuration
        {
            get;
            set;
        }


        /**
         *
         */
        public bool promote_invisible
        {
            get;
            construct set;
            default = false;
        }


        /**
         *
         */
        construct
        {
            m_names.add("device");
            m_names.add("footprint");
            m_names.add("model-name");
            m_names.add("value");

            // need to figure out how refdes is getting promoted.
            m_names.add("refdes");

            notify["configuration"].connect(on_notify_configuration);
         }


        /**
         *
         */
        public override Gee.List<AttributeChild> promote(Gee.Collection<SchematicItem> items)
        {
            var promoted = new Gee.ArrayList<AttributeChild>();

            foreach (var item in items)
            {
                var attribute = item as AttributeChild;

                if (attribute == null)
                {
                    continue;
                }

                var name = attribute.name;

                if (name == null)
                {
                    continue;
                }

                if (name == SYMVERSION)
                {
                    promoted.add(attribute);
                }
                else if (name in m_names)
                {
                    promoted.add(attribute);
                }
            }

            foreach (var attribute in promoted)
            {
                attribute.color = Color.ATTRIBUTE;
            }

            return promoted;
        }


        /**
         *
         */
        private const string SYMVERSION = "symversion";


        /**
         *
         */
        private Gee.Set<string> m_names = new Gee.HashSet<string>();


        /**
         *
         */
        private void on_notify_configuration(ParamSpec param)
        {
        }
    }
}
