namespace Geda3
{
    /**
     *
     */
    public class KeyProjectFileMapper : Mapper
    {
        public KeyProjectFileMapper(
            KeyFile key_file,
            string group,
            string key,
            ProjectFile item
            )

        {
            m_key_file = key_file;
            m_group = group;
            m_key = key;
            m_item = item;
        }


        /**
         * {@inheritDoc}
         */
        public override void @delete()

            requires(!m_deleted)
            requires(m_group != null)
            requires(m_key != null)
            requires(m_key_file != null)

        {
            try
            {
                m_key_file.remove_key(m_group, m_key);

                m_deleted = true;
            }
            catch (KeyFileError error)
            {
                
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void update()

            requires(!m_deleted)
            requires(m_group != null)
            requires(m_item != null)
            requires(m_key != null)
            requires(m_key_file != null)

        {
            m_key_file.set_string(
                m_group,
                m_key,
                m_item.file.get_path()
                );
        }


        /**
         * Indicates the mapped domain object has been deleted from the
         * database
         */
        private bool m_deleted;


        /**
         * The name of the group where the object is mapped
         */
        private string m_group;


        /**
         * The mapped domain object
         */
        private ProjectFile m_item;


        /**
         * The key where the object is mapped
         */
        private string m_key;


        /**
         * The underlying key file used for storage
         */
        private KeyFile m_key_file;
    }
}
