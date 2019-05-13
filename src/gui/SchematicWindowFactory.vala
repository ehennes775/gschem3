namespace Gschem3
{
    /**
     *
     */
    public class SchematicWindowFactory : Object
    {
        /**
         *
         */
        public SchematicWindowFactory(LibraryWidget library_widget)
        {
            m_complex_factory = new MainComplexFactory(
                library_widget
                );
        }


        /**
         *
         */
        public SchematicWindow create()
        {
            return new SchematicWindow(
                m_complex_factory
                );
        }


        /**
         *
         */
        public SchematicWindow create_with_file(File file)
        {
            return SchematicWindow.create(
                file,
                m_complex_factory
                );
        }


        private ComplexFactory m_complex_factory;
    }
}
