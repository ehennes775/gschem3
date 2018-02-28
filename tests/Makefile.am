AM_CPPFLAGS = \
	$(DEPS_CFLAGS) \
	-I/usr/local/include \
	-I../src
	-DPKGDATADIR=\"$(pkgdatadir)\" \
	-include config.h

AM_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gtk+-3.0

check_PROGRAMS = \
	test_angle \
	test_bounds \
	test_color \
	test_color_scheme \
	test_coord \
	test_line_style \
	test_print_dimension \
	test_print_units \
	test_schematic \
	test_schematic_item_bus \
	test_schematic_item_line \
	test_schematic_item_net \
	test_schematic_item_pin \
	test_schematic_reader \
	test_text_item

test_angle_SOURCES = TestAngle.vala ../src/libgeda3.vapi
test_angle_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_bounds_SOURCES = TestBounds.vala ../src/libgeda3.vapi
test_bounds_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_color_SOURCES = TestColor.vala ../src/libgeda3.vapi
test_color_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_color_scheme_SOURCES = TestColorScheme.vala ../src/libgeda3.vapi ../src/libgschem3.vapi
test_color_scheme_LDADD = ../src/libgeda3.a ../src/libgschem3.a -lm $(DEPS_LIBS)

test_coord_SOURCES = TestCoord.vala ../src/libgeda3.vapi
test_coord_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_line_style_SOURCES = TestLineStyle.vala ../src/libgeda3.vapi
test_line_style_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_print_dimension_SOURCES = TestPrintDimension.vala ../src/libgeda3.vapi
test_print_dimension_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_print_units_SOURCES = TestPrintUnits.vala ../src/libgeda3.vapi
test_print_units_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_SOURCES = TestSchematic.vala ../src/libgeda3.vapi
test_schematic_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_item_bus_SOURCES = TestSchematicItemBus.vala ../src/libgeda3.vapi
test_schematic_item_bus_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_item_line_SOURCES = TestSchematicItemLine.vala ../src/libgeda3.vapi
test_schematic_item_line_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_item_net_SOURCES = TestSchematicItemNet.vala ../src/libgeda3.vapi
test_schematic_item_net_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_item_pin_SOURCES = TestSchematicItemPin.vala ../src/libgeda3.vapi
test_schematic_item_pin_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_reader_SOURCES = TestSchematicReader.vala ../src/libgeda3.vapi
test_schematic_reader_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_text_item_SOURCES = TestTextItem.vala ../src/libgeda3.vapi
test_text_item_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

TESTS = \
	test_angle \
	test_bounds \
	test_color \
	test_color_scheme \
	test_coord \
	test_line_style \
	test_print_dimension \
	test_print_units \
	test_schematic \
	test_schematic_item_bus \
	test_schematic_item_line \
	test_schematic_item_net \
	test_schematic_item_pin \
	test_schematic_reader \
	test_text_item
