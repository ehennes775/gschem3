namespace Gschem3
{
    /**
     * An interface for document windows that can zoom
     */
    public interface Zoomable : Object
    {
        /**
         * Zoom the document to fit the view
         */
        public abstract void zoom_extents();


        /**
         * Zoom in on the center of the window
         */
        public abstract void zoom_in_center();


        /**
         * Zoom out on the center of the window
         */
        public abstract void zoom_out_center();
    }
}
