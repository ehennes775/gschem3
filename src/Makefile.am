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
	sch/Angle.vala \
	sch/AttributeChild.vala \
	sch/AttributeParent.vala \
	sch/ArcItem.vala \
	sch/Bounds.vala \
	sch/BoxItem.vala \
	sch/BusDirection.vala \
	sch/BusItem.vala \
	sch/CircleItem.vala \
	sch/CapType.vala \
	sch/Color.vala \
	sch/ComplexItem.vala \
	sch/Coord.vala \
	sch/DashType.vala \
	sch/FileVersion.vala \
	sch/FillStyle.vala \
	sch/FillType.vala \
	sch/LineItem.vala \
	sch/LineStyle.vala \
	sch/NetItem.vala \
	sch/PathCommand.vala \
	sch/PathItem.vala \
	sch/PinItem.vala \
	sch/PinType.vala \
	sch/Sweep.vala \
	sch/TextAlignment.vala \
	sch/TextItem.vala \
	sch/TextPresentation.vala \
	sch/TextSize.vala \
	sch/Visibility.vala \
	ColorScheme.vala \
	CustomAction.vala \
	Fileable.vala \
	GeeEx.vala \
	Grip.vala \
	Grippable.vala \
	GrippablePoints.vala \
	Invalidatable.vala \
	KeyFileProjectStorage.vala \
	KeyFileSymbolFolder.vala \
	KeyFileSymbolLibrary.vala \
	KeyProjectFileMapper.vala \
	LibraryFile.vala \
	LibraryFolder.vala \
	LibraryItem.vala \
	Mapper.vala \
	MapError.vala \
	NullMapper.vala \
	ParseError.vala \
	PinAttributeUpdater.vala \
	PinItemGroup.vala \
	PinSettings.vala \
	PinUpdater.vala \
	PointGrip.vala \
	PrintDimension.vala \
	PrintFormat.vala \
	PrintOrientation.vala \
	PrintUnits.vala \
	Project.vala \
	ProjectFile.vala \
	ProjectFolder.vala \
	ProjectIcon.vala \
	ProjectItem.vala \
	ProjectItemAdapter.vala \
	ProjectStorage.vala \
	RemovableItem.vala \
	RenamableItem.vala \
	Schematic.vala \
	SchematicFile.vala \
	SchematicItem.vala \
	SchematicList.vala \
	SchematicPainter.vala \
	SchematicPainterCairo.vala \
	SchematicReader.vala \
	Symbol.vala \
	SymbolLibrary.vala

libgeda3_a_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--header=libgeda3.h \
	--vapi=libgeda3.vapi

libgschem3_a_SOURCES = \
	ArcTool.vala \
	DocumentTab.vala \
	DocumentWindow.vala \
	DrawingTool.vala \
	DrawingToolBox.vala \
	DrawingToolBus.vala \
	DrawingToolCircle.vala \
	DrawingToolNet.vala \
	DrawingToolPath.vala \
	DrawingToolSelect.vala \
	ErrorDialog.vala \
	ExportBillOfMaterial.vala \
	ExportBillOfMaterialDialog.vala \
	ExportNetlist.vala \
	ExportNetlistDialog.vala \
	ExportSchematics.vala \
	Grid.vala \
	LineTool.vala \
	LibraryAdapter.vala \
	LibraryWidget.vala \
	MainWindow.vala \
	MeshGrid.vala \
	NewProjectDialog.vala \
	NoGrid.vala \
	PreviewWidget.vala \
	PinTool.vala \
	ProjectAdapter.vala \
	ProjectWidget.vala \
	Reloadable.vala \
	Savable.vala \
	SchematicWindow.vala \
	SchematicWindowSettings.vala \
	Zoomable.vala \
	ZoomTool.vala

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
	valadoc $(libgeda3_a_SOURCES) $(libgschem3_a_SOURCES) --pkg gtk+-3.0 --pkg gee-0.8 -o Gschem3 --profile=pro
