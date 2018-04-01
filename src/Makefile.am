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
	ArcItem.vala \
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
	CustomAction.vala \
	DashType.vala \
	Fileable.vala \
	FileVersion.vala \
	FillStyle.vala \
	FillType.vala \
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
	LineItem.vala \
	LineStyle.vala \
	Mapper.vala \
	MapError.vala \
	NetItem.vala \
	NullMapper.vala \
	ParseError.vala \
	PinAttributeUpdater.vala \
	PinItem.vala \
	PinItemGroup.vala \
	PinSettings.vala \
	PinType.vala \
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
	Sweep.vala \
	Symbol.vala \
	SymbolLibrary.vala \
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
