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
            try
            {
                var file = File.new_for_path(Path.build_filename(
                    TEMPLATE_FOLDER,
                    @"template.$(type)"
                    ));

                var template = new Geda3.Schematic();
                template.read_from_file(file);

                var window = new SchematicWindow(
                    m_paste_handler,
                    template.items
                    );

                notebook.add_document_window(window);
            }
            catch (Error error)
            {
                stdout.printf(@"$(error.message)\n");
            }
        }


        /**
         * {@inheritDoc}
         */
        public void open_with_file(File file)

            requires(m_paste_handler != null)
            requires(notebook != null)

        {
            notebook.add_document_window_using_file(
                file,
                create_window
                );
        }


        /**
         * {@inheritDoc}
         */
        public void open_with_files(File[] files)

            requires(m_paste_handler != null)
            requires(notebook != null)

        {
            notebook.add_document_windows_using_files(
                files,
                create_window
                );
        }


        /**
         * The configuration folder where templates reside
         */
        [CCode(cname="PKGSYSCONFDIR")]
        private extern const string TEMPLATE_FOLDER;


        /**
         *
         */
        private SchematicPasteHandler m_paste_handler;


        /**
         *
         */
        private DocumentWindow create_window(File file)
        {
            return SchematicWindow.create(
                file,
                m_paste_handler
                );
        }
    }
}
