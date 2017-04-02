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
        public override SchematicList schematic_list
        {
            get;
            construct;
        }


        construct
        {
        }
    }
}
