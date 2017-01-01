RESOURCES_FILE = Gschem3.gresource.xml

AM_CPPFLAGS = \
	$(DEPS_CFLAGS) \
	-I/usr/local/include \
	-DPKGDATADIR=\"$(pkgdatadir)\" \
	-include config.h

AM_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gdl-3.0 \
	--pkg gtk+-3.0 \
	--gresources=$(RESOURCES_FILE)

gsettings_SCHEMAS = com.github.ehennes775.gschem3.gschema.xml
EXTRA_DIST = $(gsettings_SCHEMAS)

@GSETTINGS_RULES@

GLIB_COMPILE_RESOURCES = glib-compile-resources

BUILT_SOURCES = Gschem3.gresource.c

$(BUILT_SOURCES) : $(RESOURCES_FILE) $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies $(RESOURCES_FILE))
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --generate-source $<

bin_PROGRAMS = gschem3

gschem3_SOURCES = \
	ColorScheme.vala \
	Program.vala

gschem3_LDADD = -lm $(DEPS_LIBS) libgeda3.a libgschem3.a

noinst_LIBRARIES = \
	libgeda3.a \
	libgschem3.a

libgeda3_a_SOURCES = \
	Coord.vala \
	ParseError.vala \
	Geda.vapi

libgschem3_a_SOURCES = \
	$(BUILT_SOURCES)

CLEANFILES = $(BUILT_SOURCES)

Gschem3:
	valadoc $(gschem_exp_SOURCES) --pkg gtk+-3.0 -o GschemExp
