namespace GedaTest.SchematicItemNet
{
    void check_read_write()
    {
        for (int count = 0; count < 1000; count++)
        {
            try
            {
                var memory_stream = new MemoryOutputStream.resizable();
                var output_stream = new DataOutputStream(memory_stream);

                var net0 = new Geda3.NetItem();

                net0.b_x[0] = Test.rand_int();
                net0.b_y[0] = Test.rand_int();
                net0.b_x[1] = Test.rand_int();
                net0.b_y[1] = Test.rand_int();
                net0.b_color = Test.rand_int_range(0, int.MAX);

                net0.write(output_stream);
                output_stream.close();

                var input_stream = new DataInputStream(
                    new MemoryInputStream.from_data(
                        memory_stream.steal_data(),
                        GLib.free
                        )
                    );

                var net1 = new Geda3.NetItem();
                net1.read(input_stream);

                assert_true(net0.b_x[0] == net1.b_x[0]);
                assert_true(net0.b_y[0] == net1.b_y[0]);
                assert_true(net0.b_x[1] == net1.b_x[1]);
                assert_true(net0.b_y[1] == net1.b_y[1]);
                assert_true(net0.b_color == net1.b_color);
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

        Test.add_func("/geda/libgeda/schematicitemnet/readwrite", check_read_write);

        return Test.run();
    }
}


