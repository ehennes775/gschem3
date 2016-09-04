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
	test_angle

test_angle_SOURCES = TestAngle.vala
test_angle_LDADD = -lm $(DEPS_LIBS)

TESTS = \
	test_angle
