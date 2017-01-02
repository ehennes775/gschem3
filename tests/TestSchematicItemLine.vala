namespace GedaTest.SchematicItemLine
{
    void check_read_write()
    {
        for (int count = 0; count < 1000; count++)
        {
            try
            {
                var memory_stream = new MemoryOutputStream.resizable();
                var output_stream = new DataOutputStream(memory_stream);

                var line0 = new Geda3.SchematicItemLine();

                line0.b_x[0] = Test.rand_int();
                line0.b_y[0] = Test.rand_int();
                line0.b_x[1] = Test.rand_int();
                line0.b_y[1] = Test.rand_int();
                line0.b_color = Test.rand_int_range(0, int.MAX);
                line0.b_width = Test.rand_int_range(1, int.MAX);
                line0.b_cap_type = (Geda3.CapType) Test.rand_int_range(0, Geda3.CapType.COUNT);
                line0.b_dash_type = (Geda3.DashType) Test.rand_int_range(0, Geda3.DashType.COUNT);
                line0.b_dash_length = Test.rand_int_range(1, int.MAX);
                line0.b_dash_space = Test.rand_int_range(1, int.MAX);

                line0.write(output_stream);
                output_stream.close();

                var input_stream = new DataInputStream(
                    new MemoryInputStream.from_data(
                        memory_stream.steal_data(),
                        GLib.free
                        )
                    );

                var line1 = new Geda3.SchematicItemLine();
                line1.read(input_stream);

                assert_true(line0.b_x[0] == line1.b_x[0]);
                assert_true(line0.b_y[0] == line1.b_y[0]);
                assert_true(line0.b_x[1] == line1.b_x[1]);
                assert_true(line0.b_y[1] == line1.b_y[1]);
                assert_true(line0.b_color == line1.b_color);
                assert_true(line0.b_width == line1.b_width);
                assert_true(line0.b_cap_type == line1.b_cap_type);
                assert_true(line0.b_dash_type == line1.b_dash_type);

                if (line0.b_dash_type.uses_length())
                {
                    assert_true(line0.b_dash_length == line1.b_dash_length);
                }

                if (line0.b_dash_type.uses_space())
                {
                    assert_true(line0.b_dash_space == line1.b_dash_space);
                }
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

        Test.add_func("/geda/libgeda/schematicitemline/readwrite", check_read_write);

        return Test.run();
    }
}


