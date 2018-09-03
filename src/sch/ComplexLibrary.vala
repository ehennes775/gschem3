namespace Geda3
{
    /**
     *
     */
    public class ComplexLibrary : Object
    {
        public ComplexLibrary()
        {
            m_schematic = new Schematic();

            var file = File.new_for_path("/home/ehennes/Projects/edalib/symbols/ech-crystal-4.sym");
            m_schematic.read_from_file(file);
        }


        public Schematic @get(string name)
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
                return schematic;
            }
            
            return m_schematic;
        }

        private Schematic m_schematic;
    }
}
