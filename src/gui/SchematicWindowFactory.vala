namespace Gschem3
{
    /**
     *
     */
    public class SchematicWindowFactory : SpecificWindowFactory
    {
        /**
         * Initialize a new instance
         *
         * @param library_widget
         */
        public SchematicWindowFactory(
            ComplexFactory complex_factory,
            SchematicPasteHandler paste_handler
            )
        {
            m_complex_factory = complex_factory;
            m_paste_handler = paste_handler;
        }


        /**
         * {@inheritDoc}
         */
        public override DocumentWindow create()

            requires(m_complex_factory != null)

        {
            return new SchematicWindow(
                m_complex_factory,
                m_paste_handler
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
                m_complex_factory,
                m_paste_handler
                );
        }


        /**
         * The complex factory to use for new instances
         */
        private ComplexFactory m_complex_factory;


        /**
         *
         */
        private SchematicPasteHandler m_paste_handler;
    }
}
