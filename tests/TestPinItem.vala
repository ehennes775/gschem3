namespace GedaTest.SchematicItemPin
{
    void check_construct()
    {
        var pin = new Geda3.PinItem();

        for (var index = 0; index < 2; index++)
        {
            int x;
            int y;

            pin.get_point(index, out x, out y);
            assert_true(x == 0);
            assert_true(y == 0);
        }

        assert_true(pin.color == Geda3.Color.PIN);
        assert_true(pin.pin_type == Geda3.PinType.NET);
    }


    void check_construct_with_points()
    {
        int x[2];
        int y[2];

        for (var index = 0; index < 2; index++)
        {
            x[index] = Test.rand_int();
            y[index] = Test.rand_int();
        }
        
        var pin = new Geda3.PinItem.with_points(
            x[0],
            y[0],
            x[1],
            y[1]
            );

        for (var index = 0; index < 2; index++)
        {
            int tx;
            int ty;

            pin.get_point(index, out tx, out ty);
            assert_true(tx == x[index]);
            assert_true(ty == y[index]);
        }

        assert_true(pin.color == Geda3.Color.PIN);
        assert_true(pin.pin_type == Geda3.PinType.NET);
    }


    void check_get_set_color()
    {
        int count = 0;
        var pin = new Geda3.PinItem();

        pin.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var color = Test.rand_int_range(0, int.MAX);
            count = 0;

            pin.color = color;

            assert_true(count == 1);
            assert_true(pin.color == color);
        }
    }


    void check_get_set_pin_type()
    {
        int count = 0;
        var pin = new Geda3.PinItem();

        pin.invalidate.connect(() => { count++; });

        for (var i = 0; i < 100; i++)
        {
            var pin_type = (Geda3.PinType) Test.rand_int_range(0, Geda3.PinType.COUNT);
            count = 0;

            pin.pin_type = pin_type;

            assert_true(count == 2);
            assert_true(pin.pin_type == pin_type);
        }
    }


    void check_get_set_points()
    {        
        var pin = new Geda3.PinItem();

        for (var count = 0; count < 100; count++)
        {
            int x[2];
            int y[2];

            for (var index = 0; index < 2; index++)
            {
                x[index] = Test.rand_int();
                y[index] = Test.rand_int();

                pin.set_point(index, x[index], y[index]);
            }

            for (var index = 0; index < 2; index++)
            {
                int tx;
                int ty;

                pin.get_point(index, out tx, out ty);
                assert_true(tx == x[index]);
                assert_true(ty == y[index]);
            }
        }
    }


    void check_read_write()
    {
        for (int count = 0; count < 1000; count++)
        {
            try
            {
                var memory_stream = new MemoryOutputStream.resizable();
                var output_stream = new DataOutputStream(memory_stream);

                var pin0 = new Geda3.PinItem();

                pin0.b_x[0] = Test.rand_int();
                pin0.b_y[0] = Test.rand_int();
                pin0.b_x[1] = Test.rand_int();
                pin0.b_y[1] = Test.rand_int();
                pin0.color = Test.rand_int_range(0, int.MAX);
                pin0.pin_type = (Geda3.PinType) Test.rand_int_range(0, 2);
                pin0.b_end = Test.rand_int_range(0, 2);

                pin0.write(output_stream);
                output_stream.close();

                var input_stream = new DataInputStream(
                    new MemoryInputStream.from_data(
                        memory_stream.steal_data(),
                        GLib.free
                        )
                    );

                var pin1 = new Geda3.PinItem();
                pin1.read(input_stream);

                assert_true(pin0.b_x[0] == pin1.b_x[0]);
                assert_true(pin0.b_y[0] == pin1.b_y[0]);
                assert_true(pin0.b_x[1] == pin1.b_x[1]);
                assert_true(pin0.b_y[1] == pin1.b_y[1]);
                assert_true(pin0.color == pin1.color);
                assert_true(pin0.pin_type == pin1.pin_type);
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

        Test.add_func("/geda/libgeda/schematicitempin/construct", check_construct);
        Test.add_func("/geda/libgeda/schematicitempin/constructwithpoints", check_construct_with_points);
        Test.add_func("/geda/libgeda/schematicitempin/getsetcolor", check_get_set_color);
        Test.add_func("/geda/libgeda/schematicitempin/getsetpintype", check_get_set_pin_type);
        Test.add_func("/geda/libgeda/schematicitempin/getsetpoints", check_get_set_points);
        Test.add_func("/geda/libgeda/schematicitempin/readwrite", check_read_write);

        return Test.run();
    }
}


