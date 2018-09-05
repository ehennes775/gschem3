namespace Geda3
{
    /**
     *
     */
    public class ComplexLibrary : Object
    {
        public ComplexLibrary()
        {
            var schematic = new Schematic();

            var file = File.new_for_path("/home/ehennes/Projects/edalib/symbols/ech-crystal-4.sym");
            schematic.read_from_file(file);

            m_symbol = new ComplexSymbol(schematic);
        }


        public ComplexSymbol @get(string name)
        {
            var path = Path.build_filename(
                "/home/ehennes/Projects/edalib/symbols",
                name
                );

            var file = File.new_for_path(path);

            if (file.query_exists())
            {
                var schematic = new Schematic();
                schematic.read_from_file(file);
                return new ComplexSymbol(schematic);
            }
            
            return m_symbol;
        }

        private ComplexSymbol m_symbol;
    }
}
