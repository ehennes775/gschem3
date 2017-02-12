namespace GedaTest.TextItem
{
    void check_read_write()
    {
        for (int count = 0; count < 1000; count++)
        {
            try
            {
                var memory_stream = new MemoryOutputStream.resizable();
                var output_stream = new DataOutputStream(memory_stream);

                var text0 = new Geda3.TextItem();

                text0.b_x = Test.rand_int();
                text0.b_y = Test.rand_int();
                text0.b_color = Test.rand_int_range(0, int.MAX);
                text0.b_size = Test.rand_int_range(Geda3.TextSize.MIN, Geda3.TextSize.MAX);
                text0.b_visibility = (Geda3.Visibility) Test.rand_int_range(0, Geda3.Visibility.COUNT);
                text0.b_presentation = (Geda3.TextPresentation) Test.rand_int_range(0, Geda3.TextPresentation.COUNT);
                text0.b_angle = 90 * Test.rand_int_range(0, 4);
                text0.b_alignment = (Geda3.TextAlignment) Test.rand_int_range(0, Geda3.TextAlignment.COUNT);

                text0.write(output_stream);
                output_stream.close();

                var input_stream = new DataInputStream(
                    new MemoryInputStream.from_data(
                        memory_stream.steal_data(),
                        GLib.free
                        )
                    );

                var text1 = new Geda3.TextItem();
                text1.read(input_stream);

                assert_true(text0.b_x == text1.b_x);
                assert_true(text0.b_y == text1.b_y);
                assert_true(text0.b_color == text1.b_color);
                assert_true(text0.b_size == text1.b_size);
                assert_true(text0.b_visibility == text1.b_visibility);
                assert_true(text0.b_presentation == text1.b_presentation);
                assert_true(text0.b_angle == text1.b_angle);
                assert_true(text0.b_alignment == text1.b_alignment);
                assert_true(text0.b_lines.length == text1.b_lines.length);
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

        Test.add_func("/geda/libgeda/textitem/readwrite", check_read_write);

        return Test.run();
    }
}


