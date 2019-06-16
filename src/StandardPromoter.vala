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
        construct
        {
            notify["configuration"].connect(on_notify_configuration);
        }


        /**
         *
         */
        public override Gee.List<AttributeChild> promote(
            Gee.Collection<SchematicItem> items
            )

            requires(configuration != null)

        {
            var promote_invisible = configuration.retrieve_promote_invisible();
            var promote_names = configuration.retrieve_promote_attributes();

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

                var promote = 
                    (name == REFDES) ||
                    (name == SYMVERSION) ||
                    (name in promote_names) ||
                    (promote_invisible && (attribute.visibility == Geda3.Visibility.INVISIBLE));

                if (promote)
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
         * An attribute with this name is always promoted
         *
         * TODO: need to figure out how refdes is getting promoted
         */
        private const string REFDES = "refdes";


        /**
         * An attribute with this name is always promoted
         */
        private const string SYMVERSION = "symversion";


        /**
         *
         */
        private void on_notify_configuration(ParamSpec param)
        {
        }
    }
}
