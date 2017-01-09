namespace GedaTest.Schematic
{
    void check_construct_empty()
    {
        try
        {
            var schematic = new Geda3.Schematic();

            var input_file = File.new_for_path("input.sch");
            var file_input_stream = input_file.read();
            var data_input_stream = new DataInputStream(file_input_stream);
            schematic.read(data_input_stream);

            var output_file = File.new_for_path("output.sch");
            var file_output_stream = output_file.replace(null, false, FileCreateFlags.NONE);
            var data_output_stream = new DataOutputStream(file_output_stream);
            schematic.write(data_output_stream);
        }
        catch (Error error)
        {
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
