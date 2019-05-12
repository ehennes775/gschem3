namespace Gschem3
{
    /**
     * An interface for document windows with clipboard support
     */
    public abstract interface ClipboardSupport : DocumentWindow
    {
        /**
         *
         */
        public abstract bool can_copy
        {
            get;
            protected set;
        }


        /**
         *
         */
        public abstract bool can_cut
        {
            get;
            protected set;
        }


        /**
         *
         */
        public abstract bool can_paste
        {
            get;
            protected set;
        }


        /**
         *
         *
         * @param clipboard The clipboard
         */
        public abstract void copy(Gtk.Clipboard clipboard);


        /**
         *
         *
         * @param clipboard The clipboard
         */
        public abstract void cut(Gtk.Clipboard clipboard);


        /**
         * Paste the contents of the clipboard
         *
         * @param clipboard The clipboard
         */
        public abstract void paste(Gtk.Clipboard clipboard);
    }
}
