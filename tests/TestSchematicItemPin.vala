namespace GedaTest.SchematicItemPin
{
    void check_read_write()
    {
        for (int count = 0; count < 1000; count++)
        {
            try
            {
                var memory_stream = new MemoryOutputStream.resizable();
                var output_stream = new DataOutputStream(memory_stream);

                var pin0 = new Geda3.SchematicItemPin();

                pin0.b_x[0] = Test.rand_int();
                pin0.b_y[0] = Test.rand_int();
                pin0.b_x[1] = Test.rand_int();
                pin0.b_y[1] = Test.rand_int();
                pin0.b_color = Test.rand_int_range(0, int.MAX);
                pin0.b_type = Test.rand_int_range(0, 2);
                pin0.b_end = Test.rand_int_range(0, 2);

                pin0.write(output_stream);
                output_stream.close();

                var input_stream = new DataInputStream(
                    new MemoryInputStream.from_data(
                        memory_stream.steal_data(),
                        GLib.free
                        )
                    );

                var pin1 = new Geda3.SchematicItemPin();
                pin1.read(input_stream);

                assert_true(pin0.b_x[0] == pin1.b_x[0]);
                assert_true(pin0.b_y[0] == pin1.b_y[0]);
                assert_true(pin0.b_x[1] == pin1.b_x[1]);
                assert_true(pin0.b_y[1] == pin1.b_y[1]);
                assert_true(pin0.b_color == pin1.b_color);
                assert_true(pin0.b_type == pin1.b_type);
                assert_true(pin0.b_end == pin1.b_end);
            }
            catch (Error unexpected)
            {
                assert_not_reached();
            }
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/schematicitempin/readwrite", check_read_write);

        return Test.run();
    }
}


