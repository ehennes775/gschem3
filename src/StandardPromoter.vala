namespace Geda3
{
    /**
     *
     */
    public class StandardPromoter : AttributePromoter
    {
        /**
         *
         */
        public const string SYMVERSION = "symversion";


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

            return promoted;
        }


        /**
         *
         */
        private Gee.Set<string> m_names = new Gee.HashSet<string>();
    }
}
