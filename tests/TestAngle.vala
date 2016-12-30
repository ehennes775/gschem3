namespace GedaTest.Angle
{
    void check_is_normal()
    {
        for (int count = 0; count < 10000; count++)
        {
            int angle = Test.rand_int_range (int.MIN, 0);
            stdout.printf("%d\n", angle);
            assert_true(!Geda.Angle.is_normal(angle));
        }

        for (int count = 0; count < 10000; count++)
        {
            int angle = Test.rand_int_range (360, int.MAX);
            assert_true(!Geda.Angle.is_normal(angle));
        }

        for (int count = 0; count < 100; count++)
        {
            int angle = Test.rand_int_range (0, 360);
            assert_true(Geda.Angle.is_normal(angle));
        }
    }


    void check_is_ortho()
    {
		for (int count = 0; count < 100000; count++)
		{
			int angle = 90 * Test.rand_int_range(int.MIN / 90, int.MAX / 90);
			int noise = Test.rand_int_range(1, 89);
			
			assert_true(Geda.Angle.is_ortho(angle));
			assert_true(!Geda.Angle.is_ortho(angle + noise));
		}
	}


    void check_normalize()
    {
        for (int count = 0; count < 100000; count++)
        {
            int angle = Test.rand_int_range(0, 360);
            int multiplier = Test.rand_int_range(-10000, 10001);
            int not_normalized = angle + 360 * multiplier;

            int normalized = Geda.Angle.normalize(not_normalized);

            assert_true (normalized >= 0);
            assert_true (normalized < 360);
            assert_true (normalized == angle);
        }
    }

	
	void check_make_ortho()
	{
		for (int count = 0; count < 100000; count++)
		{
			int angle = 90 * Test.rand_int_range(int.MIN / 90, int.MAX / 90);
			int noise = Test.rand_int_range(1, 44);
			
			int normalized = Geda.Angle.make_ortho(angle + noise);
			assert_true(angle == normalized);

			normalized = Geda.Angle.make_ortho(angle - noise);
			assert_true(angle == normalized);
		}
	}


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/angle/isnormal", check_is_normal);
        Test.add_func("/geda/libgeda/angle/isortho", check_is_ortho);
        Test.add_func("/geda/libgeda/angle/makeortho", check_make_ortho);
        Test.add_func("/geda/libgeda/angle/normalize", check_normalize);

        return Test.run();
    }
}
