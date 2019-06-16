namespace Gschem3
{
    /**
     *
     */
    public class DocumentWindowFactory : Object,
        DocumentOpener
    {
        /**
         *
         */
        construct
        {
            m_openers = new Gee.ArrayList<DocumentOpener>();
        }


        /**
         *
         */
        public void add_opener(DocumentOpener opener)

            requires(m_openers != null)

        {
            m_openers.add(opener);
        }


        /**
         * {@inheritDoc}
         */
        public void open_new(string type)
        {
            var opener = m_openers.first_match(i => true);
            return_if_fail(opener != null);

            opener.open_new(type);
        }


        /**
         * {@inheritDoc}
         */
        public void open_with_file(File file)
        {
            var opener = m_openers.first_match(i => true);
            return_if_fail(opener != null);

            opener.open_with_file(file);
        }


        /**
         * {@inheritDoc}
         */
        public void open_with_files(File[] files)
        {
            var opener = m_openers.first_match(i => true);
            return_if_fail(opener != null);

            opener.open_with_files(files);
        }


        /**
         *
         */
        public void remove_opener(DocumentOpener opener)

            requires(m_openers != null)

        {
            m_openers.remove(opener);
        }


        /**
         *
         */
        private Gee.ArrayList<DocumentOpener> m_openers;
    }
}
