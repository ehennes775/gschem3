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
	cfg/SystemLibrary.vala \
	lib/ContributorAdapter.vala \
	lib/LibraryContributor.vala \
	lib/LibraryContributorTest.vala \
	lib/LibraryFile.vala \
	lib/LibraryFolder.vala \
	lib/LibraryItem.vala \
	lib/LibraryStore.vala \
	lib/SymbolLibrary.vala \
	key/LibraryEntry.vala \
	prj/Project.vala \
	prj/ProjectFile.vala \
	prj/ProjectFolder.vala \
	prj/ProjectIcon.vala \
	prj/ProjectItem.vala \
	prj/ProjectItemAdapter.vala \
	prj/ProjectStorage.vala \
	prj/key/KeyFileProjectStorage.vala \
	prj/key/KeyFileSymbolFolder.vala \
	prj/key/KeyProjectFileMapper.vala \
	sch/AdjustableColor.vala \
	sch/AdjustableFillStyle.vala \
	sch/AdjustableLineStyle.vala \
	sch/AdjustableRadius.vala \
	sch/AdjustableSweep.vala \
	sch/Angle.vala \
	sch/AngleGrip.vala \
	sch/AttributeChild.vala \
	sch/AttributeCreator.vala \
	sch/AttributeParent.vala \
	sch/ArcItem.vala \
	sch/Bounds.vala \
	sch/BoxCornerGrip.vala \
	sch/BoxCornerGripCommon.vala \
	sch/BoxItem.vala \
	sch/BusDirection.vala \
	sch/BusItem.vala \
	sch/CircleItem.vala \
	sch/CapType.vala \
	sch/Color.vala \
	sch/ComplexItem.vala \
	sch/ComplexLibrary.vala \
	sch/ComplexSymbol.vala \
	sch/Coord.vala \
	sch/DashType.vala \
	sch/FileVersion.vala \
	sch/FillStyle.vala \
	sch/FillType.vala \
	sch/Grip.vala \
	sch/GripAssistant.vala \
	sch/Grippable.vala \
	sch/GrippablePoints.vala \
	sch/LineItem.vala \
	sch/LineStyle.vala \
	sch/NetItem.vala \
	sch/PathCommand.vala \
	sch/PathContext.vala \
	sch/PathCommandConverter.vala \
	sch/PathCommandReceiver.vala \
	sch/PathItem.vala \
	sch/PathPointGrip.vala \
	sch/PinItem.vala \
	sch/PinType.vala \
	sch/PointGrip.vala \
	sch/RadiusGrip.vala \
	sch/Schematic.vala \
	sch/SchematicItem.vala \
	sch/SchematicPainter.vala \
	sch/SchematicReader.vala \
	sch/StartAngleGrip.vala \
	sch/Sweep.vala \
	sch/SweepAngleGrip.vala \
	sch/TextAlignment.vala \
	sch/TextItem.vala \
	sch/TextPresentation.vala \
	sch/TextSize.vala \
	sch/Visibility.vala \
	sch/path/AbsoluteMoveToCommand.vala \
	sch/path/AbsoluteLineToCommand.vala \
	sch/path/ClosePathCommand.vala \
	sch/path/ParseUtility.vala \
	sch/path/PathCommandConverter1.vala \
	sch/path/RelativeMoveToCommand.vala \
	sch/path/RelativeLineToCommand.vala \
	AttributePromoter.vala \
	ColorScheme.vala \
	Fileable.vala \
	GeeEx.vala \
	Invalidatable.vala \
	Mapper.vala \
	MapError.vala \
	NullMapper.vala \
	ParseError.vala \
	PrintDimension.vala \
	PrintFormat.vala \
	PrintOrientation.vala \
	PrintUnits.vala \
	RemovableItem.vala \
	RenamableItem.vala \
	SchematicFile.vala \
	SchematicList.vala \
	SchematicPainterCairo.vala \
	StandardPromoter.vala \
	Symbol.vala

libgeda3_a_VALAFLAGS = \
	--target-glib=2.40 \
	--pkg gee-0.8 \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--header=libgeda3.h \
	--vapi=libgeda3.vapi

libgschem3_a_SOURCES = \
	gui/act/CustomAction.vala \
	gui/act/EditItemAction.vala \
	gui/act/ExportBillOfMaterial.vala \
	gui/act/ExportNetlist.vala \
	gui/act/ExportSchematics.vala \
	gui/aedit/AttributeCreating.vala \
	gui/aedit/AttributeEditing.vala \
	gui/aedit/AttributeEditor.vala \
	gui/aedit/AttributeState.vala \
	gui/dlg/ColumnHelper.vala \
	gui/dlg/PinEditorDialog.vala \
	gui/dlg/PinTypeColumnHelper.vala \
	gui/dlg/TextColumnHelper.vala \
	gui/pedit/ColorEditor.vala \
	gui/pedit/ColorSwatchRenderer.vala \
	gui/pedit/FillStyleEditor.vala \
	gui/pedit/LineStyleEditor.vala \
	gui/pedit/PinPropertyEditor.vala \
	gui/pedit/TextPropertyEditor.vala \
	gui/pedit/ValueState.vala \
	gui/tdlg/TextEditorDialog.vala \
	gui/ClipboardHelper.vala \
	gui/ClipboardSupport.vala \
	gui/DocumentOpener.vala \
	gui/DocumentSelector.vala \
	gui/DocumentTab.vala \
	gui/DocumentWindow.vala \
	gui/DocumentWindowNotebook.vala \
	gui/DocumentWindowFactory.vala \
	gui/DrawingTool.vala \
	gui/DrawingToolSet.vala \
	gui/ErrorDialog.vala \
	gui/ExportBillOfMaterialDialog.vala \
	gui/ExportNetlistDialog.vala \
	gui/FillSwatchRenderer.vala \
	gui/Grid.vala \
	gui/GridSize.vala \
	gui/ItemEditor.vala \
	gui/LibraryAdapter.vala \
	gui/LibraryWidget.vala \
	gui/MainWindow.vala \
	gui/NewProjectDialog.vala \
	gui/PreviewWidget.vala \
	gui/ProjectAdapter.vala \
	gui/ProjectWidget.vala \
	gui/Reloadable.vala \
	gui/Savable.vala \
	gui/SchematicPasteHandler.vala \
	gui/SchematicWindow.vala \
	gui/SchematicWindowOpener.vala \
	gui/SchematicWindowSettings.vala \
	gui/grid/MeshGrid.vala \
	gui/grid/NoGrid.vala \
	gui/tool/ArcTool.vala \
	gui/tool/AttributeFactory.vala \
	gui/tool/AttributeTool.vala \
	gui/tool/BoxTool.vala \
	gui/tool/BusTool.vala \
	gui/tool/CircleTool.vala \
	gui/tool/ComplexSelector.vala \
	gui/tool/ComplexTool.vala \
	gui/tool/LineTool.vala \
	gui/tool/NetTool.vala \
	gui/tool/PathTool.vala \
	gui/tool/PinAttributeUpdater.vala \
	gui/tool/PinItemGroup.vala \
	gui/tool/PinSettings.vala \
	gui/tool/PinTool.vala \
	gui/tool/PinUpdater.vala \
	gui/tool/PlacementFactory.vala \
	gui/tool/PlacementTool.vala \
	gui/tool/SelectTool.vala \
	gui/tool/TextFactory.vala \
	gui/tool/TextTool.vala \
	gui/tool/ZoomTool.vala \
	gui/wid/AlignmentComboBox.vala \
	gui/wid/ColorComboBox.vala \
	gui/wid/PropertyComboBox.vala \
	gui/wid/RotationComboBox.vala \
	gui/wid/TextSizeComboBox.vala

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
