namespace Geda3
{
    /**
     * An interface for schematic items that provide grips
     */
    public interface Grippable : SchematicItem
    {
        /**
         * Create grips for this schematic item
         *
         * @param assistant Provides functionalty from the GUI
         */
        public abstract Gee.Collection<Grip> create_grips(
            GripAssistant assistant
            );
    }
}
