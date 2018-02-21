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

                text0.x = Test.rand_int();
                text0.y = Test.rand_int();
                text0.color = Test.rand_int_range(0, int.MAX);
                text0.size = Test.rand_int_range(Geda3.TextSize.MIN, Geda3.TextSize.MAX);
                text0.visibility = (Geda3.Visibility) Test.rand_int_range(0, Geda3.Visibility.COUNT);
                text0.presentation = (Geda3.TextPresentation) Test.rand_int_range(0, Geda3.TextPresentation.COUNT);
                text0.angle = 90 * Test.rand_int_range(0, 4);
                text0.alignment = (Geda3.TextAlignment) Test.rand_int_range(0, Geda3.TextAlignment.COUNT);

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

                assert_true(text0.x == text1.x);
                assert_true(text0.y == text1.y);
                assert_true(text0.color == text1.color);
                assert_true(text0.size == text1.size);
                assert_true(text0.visibility == text1.visibility);
                assert_true(text0.presentation == text1.presentation);
                assert_true(text0.angle == text1.angle);
                assert_true(text0.alignment == text1.alignment);
                assert_true(text0.text == text1.text);
            }
            catch (Error unexpected)
            {
                assert_not_reached();
            }
        }
    }


    void check_get_set_alignment()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var alignment = (Geda3.TextAlignment) Test.rand_int_range(
                0,
                Geda3.TextAlignment.COUNT
                );

            count = 0;

            item.alignment = alignment;

            assert_true(count == 2);
            assert_true(item.alignment == alignment);
        }
    }


    void check_get_set_angle()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var angle = Test.rand_int();
            count = 0;

            item.angle = angle;

            assert_true(count == 2);
            assert_true(item.angle == angle);
        }
    }


    void check_get_set_color()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var color = Test.rand_int_range(0, int.MAX);
            count = 0;

            item.color = color;

            assert_true(count == 1);
            assert_true(item.color == color);
        }
    }


    void check_get_set_size()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var size = Test.rand_int_range(
                Geda3.TextSize.MIN,
                Geda3.TextSize.MAX
                );

            count = 0;

            item.size = size;

            assert_true(count == 2);
            assert_true(item.size == size);
        }
    }


    void check_get_set_text()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        string[] test_values =
        {
            "",
            "Text",
            " Text",
            "Text ",
            " Text ",
            "Text\nText",
            "Text\nText\n",
            "\nText\nText",
            "Text \n Text",
            " Text\nText ",
        };

        foreach (var text in test_values)
        {
            count = 0;

            item.text = text;

            assert_true(count == 2);
            assert_true(item.text == text);
        }
    }


    void check_get_set_visibility()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var visibility = (Geda3.Visibility) Test.rand_int_range(0, Geda3.Visibility.COUNT);
            count = 0;

            item.visibility = visibility;

            assert_true(count == 2);
            assert_true(item.visibility == visibility);
        }
    }


    void check_get_set_x()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var x = Test.rand_int();
            count = 0;

            item.x = x;

            assert_true(count == 2);
            assert_true(item.x == x);
        }
    }


    void check_get_set_y()
    {
        int count = 0;
        var item = new Geda3.TextItem();

        item.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var y = Test.rand_int();
            count = 0;

            item.y = y;

            assert_true(count == 2);
            assert_true(item.y == y);
        }
    }


    void check_visible_text()
    {
        var item = new Geda3.TextItem();

        string[,] test_values =
        {
            { "value=100", "value", "100" }
        };

        for (var index = 0; index < test_values.length[0]; index++)
        {
            item.text = test_values[index,0];

            item.presentation = Geda3.TextPresentation.BOTH;
            assert_true(item.visible_text == test_values[index,0]);

            item.presentation = Geda3.TextPresentation.NAME;
            assert_true(item.visible_text == test_values[index,1]);

            item.presentation = Geda3.TextPresentation.VALUE;
            assert_true(item.visible_text == test_values[index,2]);
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/textitem/readwrite", check_read_write);
        Test.add_func("/geda/libgeda/textitem/getsetalignment", check_get_set_alignment);
        Test.add_func("/geda/libgeda/textitem/getsetangle", check_get_set_angle);
        Test.add_func("/geda/libgeda/textitem/getsetcolor", check_get_set_color);
        Test.add_func("/geda/libgeda/textitem/getsetsize", check_get_set_size);
        Test.add_func("/geda/libgeda/textitem/getsettext", check_get_set_text);
        Test.add_func("/geda/libgeda/textitem/getsetx", check_get_set_x);
        Test.add_func("/geda/libgeda/textitem/getsety", check_get_set_y);
        Test.add_func("/geda/libgeda/textitem/getsetvisibility", check_get_set_visibility);
        Test.add_func("/geda/libgeda/textitem/visibletext", check_visible_text);

        return Test.run();
    }
}


