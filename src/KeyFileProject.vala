namespace Geda3
{
    /**
     * A project stored inside a keyfile
     */
    public class KeyFileProject : Project
    {
        /**
         * {@inheritDoc}
         */
        public override File file
        {
            get;
            protected set;
        }


        /**
         * {@inheritDoc}
         */
        public override SchematicList schematic_list
        {
            get;
            protected set;
        }


        /**
         *
         *
         */
        construct
        {
            m_key_file = new KeyFile();

            //schematic_list = new KeyFileSchematicList(m_key_file);
        }


        /**
         *
         *
         */
        public KeyFileProject.create(File file)

            requires(m_key_file != null)

        {
            var exists = file.query_exists();

            if (exists)
            {
                // error
            }
        }


        /**
         *
         *
         */
        public KeyFileProject.open(File file)

            requires(m_key_file != null)

        {
            this.file = file;

            m_key_file.load_from_file(
                file.get_path(),
                KeyFileFlags.KEEP_COMMENTS | KeyFileFlags.KEEP_TRANSLATIONS
                );
        }


        /**
         * {@inheritDoc}
         */
        public override void save() throws FileError

            requires(file != null)
            requires(m_key_file != null)

        {
            m_key_file.save_to_file(file.get_path());
        }


        /**
         *
         */
        private KeyFile m_key_file;
    }
}
