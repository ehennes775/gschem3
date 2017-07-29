namespace Gschem3
{
    public class CustomAction : Object
    {
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
