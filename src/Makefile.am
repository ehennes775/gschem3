RESOURCES_FILE = Gschem3.gresource.xml

AM_CPPFLAGS = \
	$(DEPS_CFLAGS) \
	-I/usr/local/include \
	-DPKGDATADIR=\"$(pkgdatadir)\" \
	-include config.h

gsettings_SCHEMAS = com.github.ehennes775.gschem3.gschema.xml
EXTRA_DIST = $(gsettings_SCHEMAS)

@GSETTINGS_RULES@

GLIB_COMPILE_RESOURCES = glib-compile-resources

BUILT_SOURCES = Gschem3.gresource.c

$(BUILT_SOURCES) : $(RESOURCES_FILE) $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies $(RESOURCES_FILE))
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --generate-source $<

bin_PROGRAMS = gschem3

# TODO: Resources don't get pulled in from a static library, so as a
# workaround, the resources will get linked with the executable

gschem3_SOURCES = \
	Program.vala \
	$(BUILT_SOURCES)

gschem3_LDADD = libgschem3.a libgeda3.a -lm $(DEPS_LIBS)

gschem3_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--pkg libgeda3 \
	--pkg libgschem3 \
	--vapidir=.

noinst_LIBRARIES = \
	libgeda3.a \
	libgschem3.a

libgeda3_a_SOURCES = \
	Angle.vala \
	AttributeChild.vala \
	AttributeParent.vala \
	Bounds.vala \
	BoxItem.vala \
	BusDirection.vala \
	BusItem.vala \
	CapType.vala \
	CircleItem.vala \
	Color.vala \
	ColorScheme.vala \
	Coord.vala \
	DashType.vala \
	Fileable.vala \
	FileVersion.vala \
	FillType.vala \
	NetItem.vala \
	ParseError.vala \
	PinType.vala \
	Schematic.vala \
	SchematicItem.vala \
	SchematicItemLine.vala \
	SchematicItemPin.vala \
	SchematicPainter.vala \
	SchematicPainterCairo.vala \
	SchematicReader.vala \
	TextAlignment.vala \
	TextItem.vala \
	TextPresentation.vala \
	TextSize.vala \
	Visibility.vala

libgeda3_a_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--header=libgeda3.h \
	--vapi=libgeda3.vapi

libgschem3_a_SOURCES = \
	DocumentTab.vala \
	DocumentWindow.vala \
	ErrorDialog.vala \
	MainWindow.vala \
	ProjectWidget.vala \
	Reloadable.vala \
	Savable.vala \
	SchematicWindow.vala

libgschem3_a_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gtk+-3.0 \
	--pkg libgeda3 \
	--header=libgschem3.h \
	--vapidir=. \
	--vapi=libgschem3.vapi \
	--gresources=$(RESOURCES_FILE)

CLEANFILES = $(BUILT_SOURCES)

Gschem3:
	valadoc $(libgeda3_a_SOURCES) $(libgschem3_a_SOURCES) --pkg gtk+-3.0 --pkg gee-0.8 -o Gschem3
