namespace Geda3
{
    /**
     *
     */
    public class ClosePathCommand : PathCommand
    {
        /**
         *
         *
         * The close path command can either be upper or lower case.
         */
        public const char ID = 'z';


        /**
         * {@inheritDoc}
         */
        public override void put(PathCommandReceiver receiver)
        {
            receiver.close_path();
        }
    }
}
