namespace Geda3
{
    /**
     *
     */
    public class ComplexLibrary : Object
    {
        construct
        {
            m_paths = new Gee.ArrayList<string>();

            m_paths.add(
                "/home/ehennes/Projects/edalib/symbols"
                );

            m_paths.add(
                "/home/ehennes/Projects/amlocker2/sym"
                );
        }

        public ComplexLibrary()
        {
            var schematic = new Schematic();

            var file = File.new_for_path("/home/ehennes/Projects/edalib/symbols/ech-crystal-4.sym");
            schematic.read_from_file(file);

            m_symbol = new ComplexSymbol(schematic);
        }


        public ComplexSymbol @get(string name)
        {
            foreach (var path_string in m_paths)
            {
                var path = Path.build_filename(
                    path_string,
                    name
                    );

                var file = File.new_for_path(path);

                if (file.query_exists())
                {
                    var schematic = new Schematic();
                    schematic.read_from_file(file);
                    return new ComplexSymbol(schematic);
                }
            }
            
            return m_symbol;
        }


        private Gee.List<string> m_paths;


        private ComplexSymbol m_symbol;
    }
}
