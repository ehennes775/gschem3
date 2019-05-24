namespace Gschem3
{
    public abstract class CustomAction : Object
    {
        /**
         * An action for this operation
         */
        public Action action
        {
            get;
            protected set;
        }


        /**
         * Initialize the class
         */
        static construct
        {
            try
            {
                s_regex = new Regex("([a-z])([A-Z])");
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * Convert the class name into the action name
         *
         * TODO: class names include the namespace name
         * 
         * @param class_name The name of the class in upper camel case
         * @param action_name The name of the class in
         */
        public static string convert_name(string camel_case)
        {
            try
            {
                return s_regex.replace(
                    camel_case,
                    camel_case.length,
                    0,
                    "\\1-\\l\\2"
                    ).down();
            }
            catch (Error error)
            {
                return null;
            }
        }


        /**
         * Regex for converting class names into action names
         */
        private static Regex s_regex;
    }
}
