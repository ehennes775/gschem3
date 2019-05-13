namespace Gschem3
{
    /**
     *
     */
    public class SchematicWindowFactory : DocumentWindowFactory
    {
        /**
         * Initialize a new instance
         *
         * @param library_widget
         */
        public SchematicWindowFactory(LibraryWidget library_widget)
        {
            m_complex_factory = new MainComplexFactory(
                library_widget
                );
        }


        /**
         * {@inheritDoc}
         */
        public override DocumentWindow create()

            requires(m_complex_factory != null)

        {
            return new SchematicWindow(
                m_complex_factory
                );
        }


        /**
         * {@inheritDoc}
         */
        public override DocumentWindow create_with_file(File file)

            requires(m_complex_factory != null)

        {
            return SchematicWindow.create(
                file,
                m_complex_factory
                );
        }


        /**
         * The complex factory to use for new instances
         */
        private ComplexFactory m_complex_factory;
    }
}
