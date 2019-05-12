namespace Gschem3
{
    /**
     * An abstract base class representing the editing state of a row
     */
    public abstract class AttributeState : Object
    {
        /**
         *
         */
        static construct
        {
            try
            {
                s_name_regex = new Regex("^([^=]+)$");
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }

        /**
         * The name of the attribute
         */
        public abstract string name
        {
            get;
            set;
        }


        /**
         * Indicates the name of the attribute is valid
         */
        public bool name_valid
        {
            get;
            protected set;
        }


        /**
         *
         */
        public abstract Geda3.TextPresentation presentation
        {
            get;
            set;
        }


        /**
         * Indicates this row is requesting removal
         *
         * Rows representing temporary states use this property to
         * indicate that the usefullness of the row is done.
         */
        public abstract bool request_removal
        {
            get;
        }


        /**
         * The value of the attribute
         */
        public abstract string @value
        {
            get;
            set;
        }


        /**
         * Indicates the value of the attribute is valid
         */
        public bool value_valid
        {
            get;
            protected set;
        }


        /**
         * The visibility of the item
         */
        public abstract bool visible
        {
            get;
            set;
        }


        /**
         * Validate an attribute name
         *
         * This function should move elsewhere in the future.
         *
         * @param name The name of the attribute
         * @return True, if the argument represents a valid name
         */
        protected static bool validate_name(string name)

            requires(s_name_regex != null)

        {
            return s_name_regex.match(name);
        }


        /**
         * Validate an attribute value
         *
         * This function should move elsewhere in the future.
         *
         * @param name The value of the attribute
         * @return True, if the argument represents a valid value
         */
        protected static bool validate_value(string @value)
        {
            return @value.validate();
        }


        /**
         * A regex for to validating attribute names
         */
        private static Regex s_name_regex;
    }
}
