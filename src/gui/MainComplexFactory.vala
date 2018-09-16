namespace Gschem3
{
    /**
     * {@inheritDoc}
     */
    public class MainComplexFactory : ComplexFactory
    {
        /**
         *
         */
        public LibraryWidget library_widget
        {
            get
            {
                return b_library_widget;
            }
            set
            {
                if (b_library_widget != null)
                {
                    b_library_widget.notify["symbol-name"].disconnect(on_notify_name);
                }

                b_library_widget = value;

                if (b_library_widget != null)
                {
                    b_library_widget.notify["symbol-name"].connect(on_notify_name);
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public override string? name
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
            default = null;
        }


        /**
         * Create a new complex item factory
         */
        public MainComplexFactory(LibraryWidget library_widget1)
        {
            library_widget = library_widget1;
        }


        /**
         * {@inheritDoc}
         */
        public override Geda3.ComplexItem? create()
        {
            var complex = new Geda3.ComplexItem.with_name(m_library, b_name);

            var promoted = m_promoter.promote(complex.symbol.schematic.items);

            foreach (var attribute in promoted)
            {
                complex.attach(attribute);
            }

            return complex;
        }


        /**
         *
         */
        private LibraryWidget b_library_widget;


        /**
         * The name of the complex item in the library
         */
        private string b_name;


        // temp located here for development
        private static Geda3.ComplexLibrary m_library = new Geda3.ComplexLibrary();


        // temp located here for development
        private static Geda3.AttributePromoter m_promoter = new Geda3.StandardPromoter();


        /**
         *
         */
        private void on_notify_name(ParamSpec param)

            requires(b_library_widget != null)

        {
            name = b_library_widget.symbol_name;

            recreate();
        }
    }
}
