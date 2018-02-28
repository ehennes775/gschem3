namespace GedaTest.SchematicItemLine
{
    void check_construct()
    {
        var line = new Geda3.SchematicItemLine();

        assert_true(line.b_x[0] == 0);
        assert_true(line.b_y[0] == 0);
        assert_true(line.b_x[1] == 0);
        assert_true(line.b_y[1] == 0);
        assert_true(line.color == Geda3.Color.GRAPHIC);
        assert_true(line.width == 10);
        
        assert_true(line.line_style.cap_type == Geda3.CapType.NONE);
        assert_true(line.line_style.dash_length == Geda3.DashType.DEFAULT_LENGTH);
        assert_true(line.line_style.dash_length == Geda3.DashType.DEFAULT_SPACE);
        assert_true(line.line_style.dash_type == Geda3.DashType.SOLID);
    }


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
                line0.color = Test.rand_int_range(0, int.MAX);
                line0.width = Test.rand_int_range(1, int.MAX);
                line0.line_style.cap_type = (Geda3.CapType) Test.rand_int_range(0, Geda3.CapType.COUNT);
                line0.line_style.dash_type = (Geda3.DashType) Test.rand_int_range(0, Geda3.DashType.COUNT);
                line0.line_style.dash_length = Test.rand_int_range(1, int.MAX);
                line0.line_style.dash_space = Test.rand_int_range(1, int.MAX);

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
                assert_true(line0.color == line1.color);
                assert_true(line0.width == line1.width);
                assert_true(line0.line_style.cap_type == line1.line_style.cap_type);
                assert_true(line0.line_style.dash_type == line1.line_style.dash_type);

                if (line0.line_style.dash_type.uses_length())
                {
                    assert_true(line0.line_style.dash_length == line1.line_style.dash_length);
                }

                if (line0.line_style.dash_type.uses_space())
                {
                    assert_true(line0.line_style.dash_space == line1.line_style.dash_space);
                }
            }
            catch (Error unexpected)
            {
                assert_not_reached();
            }
        }
    }


    void check_get_set()
    {
        int invalidate_count = 0;
        var line = new Geda3.SchematicItemLine();

        line.invalidate.connect(() => { invalidate_count++; });

        for (var count = 0; count < 100; count++)
        {
            var cap_type = (Geda3.CapType) Test.rand_int_range(
                0,
                Geda3.CapType.COUNT
                );

            var dash_type = (Geda3.DashType) Test.rand_int_range(
                0,
                Geda3.DashType.COUNT
                );

            var dash_length = Test.rand_int_range(0, int.MAX);
            var dash_space = Test.rand_int_range(0, int.MAX);

            invalidate_count = 0;

            line.line_style.cap_type = cap_type;
            assert_true(invalidate_count == 1);

            line.line_style.dash_length = dash_length;
            assert_true(invalidate_count == 2);

            line.line_style.dash_space = dash_space;
            assert_true(invalidate_count == 3);

            line.line_style.dash_type = dash_type;
            assert_true(invalidate_count == 4);

            assert_true(line.line_style.cap_type == cap_type);
            assert_true(line.line_style.dash_length == dash_length);
            assert_true(line.line_style.dash_space == dash_space);
            assert_true(line.line_style.dash_type == dash_type);
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/schematicitemline/construct", check_construct);
        Test.add_func("/geda/libgeda/schematicitemline/readwrite", check_read_write);
        Test.add_func("/geda/libgeda/schematicitemline/getset", check_get_set);

        return Test.run();
    }
}


