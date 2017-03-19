namespace Gschem3
{
    /**
     *
     */
    namespace ErrorDialog
    {
        /**
         * Show an error dialog for a file operation
         *
         * @param parent The parent window for the dialog box
         * @param error The error that was encountered
         * @param file The file that encountered the error
         */
        public void show_with_file(Gtk.Window? parent, Error error, File? file)
        {
            stderr.printf("%s\n", error.message);
        }
    }
}
