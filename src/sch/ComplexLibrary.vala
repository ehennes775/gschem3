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

                    // Currently, a shortcut:
                    // change all the detached attributes from the
                    // detached color to the attached color.

                    foreach (var item in schematic.items)
                    {
                        var attribute = item as AttributeChild;

                        if (attribute == null)
                        {
                            continue;
                        }

                        if (attribute.name == null)
                        {
                            continue;
                        }

                        if (attribute.visibility != Visibility.VISIBLE)
                        {
                            continue;
                        }

                        attribute.color = Color.ATTRIBUTE;
                    }

                    return new ComplexSymbol(schematic);
                }
            }
            
            return m_symbol;
        }


        private Gee.List<string> m_paths;


        private ComplexSymbol m_symbol;
    }
}
