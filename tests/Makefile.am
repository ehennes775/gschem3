AM_CPPFLAGS = \
	$(DEPS_CFLAGS) \
	-I/usr/local/include \
	-DPKGDATADIR=\"$(pkgdatadir)\" \
	-include config.h

AM_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gtk+-3.0

check_PROGRAMS = \
	test_angle \
	test_color_scheme \
	test_coord

test_angle_SOURCES = TestAngle.vala ../src/Geda.vapi
test_angle_LDADD = -lm $(DEPS_LIBS)

test_color_scheme_SOURCES = TestColorScheme.vala ../src/ColorScheme.vala
test_color_scheme_LDADD = -lm $(DEPS_LIBS)

test_coord_SOURCES = TestCoord.vala ../src/Coord.vala
test_coord_LDADD = -lm $(DEPS_LIBS)

TESTS = \
	test_angle \
	test_color_scheme \
	test_coord
