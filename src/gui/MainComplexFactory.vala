namespace Gschem3
{
    /**
     * {@inheritDoc}
     */
    public class MainComplexFactory : ComplexFactory
    {
        /**
         * {@inheritDoc}
         */
        public override string name
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
        public MainComplexFactory()
        {
            name = "ech-crystal-4.sym";
        }


        /**
         * {@inheritDoc}
         */
        public override Geda3.ComplexItem? create()
        {
            return new Geda3.ComplexItem.with_name(m_library, b_name);
        }


        /**
         * The name of the complex item in the library
         */
        private string b_name;


        // temp located here for development
        private static Geda3.ComplexLibrary m_library = new Geda3.ComplexLibrary();
    }
}
