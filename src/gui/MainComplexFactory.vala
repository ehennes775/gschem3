namespace Gschem3
{
    /**
     * {@inheritDoc}
     */
    public class MainComplexFactory : ComplexFactory
    {
        /**
         * {@inheritDoc}
         */
        public override string name
        {
            get
            {
                return b_name;
            }
            construct set
            {
                b_name = value;

                recreate();
            }
            default = "ech-crystal-4.sym";
        }


        /**
         * Create a new complex item factory
         */
        public MainComplexFactory(LibraryWidget library_widget)
        {
            name = "ech-crystal-4.sym";

            m_library_widget = library_widget;
            m_library_widget.notify["symbol-name"].connect(on_notify_name);
        }


        /**
         * {@inheritDoc}
         */
        public override Geda3.ComplexItem? create()
        {
            return new Geda3.ComplexItem.with_name(m_library, b_name);
        }


        /**
         * The name of the complex item in the library
         */
        private string b_name;


        private LibraryWidget m_library_widget;
        

        // temp located here for development
        private static Geda3.ComplexLibrary m_library = new Geda3.ComplexLibrary();


        private void on_notify_name(ParamSpec param)
        {
            stdout.printf("notify\n");
            name = m_library_widget.symbol_name;
            recreate();
        }
    }
}
