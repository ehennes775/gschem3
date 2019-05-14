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
            SchematicPasteHandler paste_handler
            )
        {
            m_paste_handler = paste_handler;
        }


        /**
         * {@inheritDoc}
         */
        public override DocumentWindow create()

            requires(m_paste_handler != null)

        {
            return new SchematicWindow(
                m_paste_handler
                );
        }


        /**
         * {@inheritDoc}
         */
        public override DocumentWindow create_with_file(File file)

            requires(m_paste_handler != null)

        {
            return SchematicWindow.create(
                file,
                m_paste_handler
                );
        }


        /**
         *
         */
        private SchematicPasteHandler m_paste_handler;
    }
}
