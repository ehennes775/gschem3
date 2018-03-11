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
	test_bus_item \
	test_color \
	test_color_scheme \
	test_coord \
	test_fill_style \
	test_line_item \
	test_line_style \
	test_net_item \
	test_pin_item \
	test_print_dimension \
	test_print_units \
	test_schematic \
	test_schematic_reader \
	test_symbol_library \
	test_sweep \
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

test_fill_style_SOURCES = TestFillStyle.vala ../src/libgeda3.vapi
test_fill_style_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_line_style_SOURCES = TestLineStyle.vala ../src/libgeda3.vapi
test_line_style_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_print_dimension_SOURCES = TestPrintDimension.vala ../src/libgeda3.vapi
test_print_dimension_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_print_units_SOURCES = TestPrintUnits.vala ../src/libgeda3.vapi
test_print_units_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_SOURCES = TestSchematic.vala ../src/libgeda3.vapi
test_schematic_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_bus_item_SOURCES = TestBusItem.vala ../src/libgeda3.vapi
test_bus_item_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_line_item_SOURCES = TestLineItem.vala ../src/libgeda3.vapi
test_line_item_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_net_item_SOURCES = TestNetItem.vala ../src/libgeda3.vapi
test_net_item_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_pin_item_SOURCES = TestPinItem.vala ../src/libgeda3.vapi
test_pin_item_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_schematic_reader_SOURCES = TestSchematicReader.vala ../src/libgeda3.vapi
test_schematic_reader_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_symbol_library_SOURCES = TestSymbolLibrary.vala ../src/libgeda3.vapi
test_symbol_library_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_sweep_SOURCES = TestSweep.vala ../src/libgeda3.vapi
test_sweep_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

test_text_item_SOURCES = TestTextItem.vala ../src/libgeda3.vapi
test_text_item_LDADD = ../src/libgeda3.a -lm $(DEPS_LIBS)

TESTS = \
	test_angle \
	test_bounds \
	test_bus_item \
	test_color \
	test_color_scheme \
	test_coord \
	test_fill_style \
	test_line_item \
	test_line_style \
	test_net_item \
	test_pin_item \
	test_print_dimension \
	test_print_units \
	test_schematic \
	test_schematic_reader \
	test_symbol_library \
	test_sweep \
	test_text_item
