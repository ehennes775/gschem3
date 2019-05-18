namespace Gschem3
{
    /**
     *
     */
    public class DocumentWindowFactory : Object
    {
        /**
         *
         */
        construct
        {
            m_factories = new Gee.ArrayList<SpecificWindowFactory>();
        }


        /**
         *
         */
        public void add_factory(SpecificWindowFactory factory)
        {

            m_factories.add(factory);
        }


        /**
         * Create a new document window
         *
         * @param name Specifies the type of document window
         */
        public DocumentWindow create(string name)
        {
            var factory = m_factories.first_match(i => true);
            return_val_if_fail(factory != null, null);

            return factory.create();
        }


        /**
         * Create a new window from a file
         *
         * @param file The file to edit in the schematic window
         */
        public DocumentWindow create_with_file(File file)
        {
            var factory = m_factories.first_match(i => true);
            return_val_if_fail(factory != null, null);

            return factory.create_with_file(file);
        }


        /**
         *
         */
        private Gee.ArrayList<SpecificWindowFactory> m_factories;
    }
}
