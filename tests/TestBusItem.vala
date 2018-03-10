namespace GedaTest.SchematicItemBus
{
    void check_read_write()
    {
        for (int count = 0; count < 1000; count++)
        {
            try
            {
                var memory_stream = new MemoryOutputStream.resizable();
                var output_stream = new DataOutputStream(memory_stream);

                var bus0 = new Geda3.BusItem();

                bus0.b_x[0] = Test.rand_int();
                bus0.b_y[0] = Test.rand_int();
                bus0.b_x[1] = Test.rand_int();
                bus0.b_y[1] = Test.rand_int();
                bus0.b_color = Test.rand_int_range(0, int.MAX);
                bus0.b_direction = Test.rand_int_range(0, 2);

                bus0.write(output_stream);
                output_stream.close();

                var input_stream = new DataInputStream(
                    new MemoryInputStream.from_data(
                        memory_stream.steal_data(),
                        GLib.free
                        )
                    );

                var bus1 = new Geda3.BusItem();
                bus1.read(input_stream);

                assert_true(bus0.b_x[0] == bus1.b_x[0]);
                assert_true(bus0.b_y[0] == bus1.b_y[0]);
                assert_true(bus0.b_x[1] == bus1.b_x[1]);
                assert_true(bus0.b_y[1] == bus1.b_y[1]);
                assert_true(bus0.b_color == bus1.b_color);
                assert_true(bus0.b_direction == bus1.b_direction);
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

        Test.add_func("/geda/libgeda/schematicitembus/readwrite", check_read_write);

        return Test.run();
    }
}


