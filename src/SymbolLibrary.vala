namespace Geda3
{
    /**
     * Schematic symbol libraries
     */
    public class SymbolLibrary
    {

        public signal void symbol_used(Symbol symbol);
        public signal void symbol_unused(string name);


        public SymbolLibrary()
        {
            m_names = new Gee.HashMap<void*,string>();
            m_symbols = new Gee.HashMap<string,weak Symbol>();
        }


        /**
         * Add a symbol folder to the library
         *
         * @param library The folder to add to the library
         */
        public virtual bool add(File library)
        {
            return false;
        }


        /**
         * Get a symbol from the library
         *
         * @param name The name of the symbol
         */
        public Symbol @get(string name)

            ensures(result.name == name)

        {
            if (!m_symbols.has_key(name))
            {
                var symbol = new Symbol(name);

                symbol.weak_ref(on_weak_notify);

                m_names[symbol] = name;
                m_symbols[name] = symbol;

                symbol_used(symbol);

                return symbol;
            }

            return m_symbols[name];
        }


        /**
         * Lookup table to get the name of finalized objects
         */
        private Gee.HashMap<void*,string> m_names;


        /**
         * Interned symbols
         */
        private Gee.HashMap<string,weak Symbol> m_symbols;


        /**
         *
         */
        private void on_weak_notify(Object object)

            requires(m_names.has_key(object))

        {
            var name = m_names[object];

            return_if_fail(m_symbols.has_key(name));

            m_symbols.unset(name);

            symbol_unused(name);
        }
    }
}
