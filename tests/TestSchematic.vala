namespace GedaTest.Schematic
{
    void check_construct_empty()
    {
        try
        {
            var schematic = new Geda3.Schematic();

            var input_file = File.new_for_path("input.sch");
            schematic.read_from_file(input_file);

            var output_file = File.new_for_path("output.sch");
            var file_output_stream = output_file.replace(null, false, FileCreateFlags.NONE);
            var data_output_stream = new DataOutputStream(file_output_stream);
            schematic.write(data_output_stream);
        }
        catch (Error error)
        {
            stderr.printf("%s", error.message);
            assert_not_reached();
        }
    }




    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/schematic/construct", check_construct_empty);

        return Test.run();
    }
}
