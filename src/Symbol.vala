namespace Geda3
{
    /**
     *
     */
    public class Symbol : Object
    {
        /**
         *
         */
        public string name
        {
            get;
            construct;
        }


        /**
         *
         * @param name The name of the symbol
         */
        public Symbol(string name)
        {
            Object(name : name);
        }
    }
}
