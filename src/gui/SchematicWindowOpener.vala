namespace Gschem3
{
    /**
     *
     */
    public class SchematicWindowOpener : Object,
        DocumentOpener
    {
        public DocumentWindowNotebook notebook
        {
            get;
            set;
        }


        /**
         * Initialize a new instance
         *
         * @param library_widget
         */
        public SchematicWindowOpener(
            DocumentWindowNotebook notebook,
            SchematicPasteHandler paste_handler
            )
        {
            this.notebook = notebook;
            m_paste_handler = paste_handler;
        }


        /**
         * {@inheritDoc}
         */
        public void open_new(string type)

            requires(m_paste_handler != null)
            requires(notebook != null)

        {
            var window = new SchematicWindow(
                m_paste_handler
                );

            notebook.add_document_window(window);
        }


        /**
         * {@inheritDoc}
         */
        public void open_with_file(File file)

            requires(m_paste_handler != null)
            requires(notebook != null)

        {
            var window = SchematicWindow.create(
                file,
                m_paste_handler
                );

            notebook.add_document_window(window);
        }


        /**
         * {@inheritDoc}
         */
        public void open_with_files(File[] files)

            requires(m_paste_handler != null)
            requires(notebook != null)

        {
            foreach (var file in files)
            {
                open_with_file(file);
            }
        }


        /**
         *
         */
        private SchematicPasteHandler m_paste_handler;
    }
}
