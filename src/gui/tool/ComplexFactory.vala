namespace Gschem3
{
    /**
     *
     */
    public class ComplexFactory : Object
    {
        /**
         *
         */
        public signal void recreate();


        /**
         *
         */
        public string name
        {
            get
            {
                return b_name;
            }
            construct set
            {
                b_name = value;

                recreate();
            }
            default = "ech-crystal-4.sym";
        }


        /**
         * Create a new complex item factory
         */
        public ComplexFactory()
        {
            name = "ech-crystal-4.sym";
        }


        /**
         * Create a new complex item factory
         */
        public Geda3.ComplexItem? create()
        {
            return new Geda3.ComplexItem.with_name(m_library, b_name);
        }


        /**
         * Create a new complex item factory
         */
        private string b_name;


        // temp located here for development
        private static Geda3.ComplexLibrary m_library = new Geda3.ComplexLibrary();
    }
}
