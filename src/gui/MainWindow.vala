namespace Gschem3
{
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/MainWindow.ui.xml")]
    public class MainWindow : Gtk.ApplicationWindow
    {
        /**
         * The currently open project
         *
         * This property functions as a source for bindings. A null
         * indicates no project is open.
         */
        public Geda3.Project? project
        {
            get;
            private set;
        }


        /**
         * Initialize the class
         */
        static construct
        {
            stdout.printf("%s\n",typeof(AttributeEditor).name());
            stdout.printf("%s\n",typeof(LibraryWidget).name());
            stdout.printf("%s\n",typeof(PreviewWidget).name());
            stdout.printf("%s\n",typeof(ProjectWidget).name());
        }


        ExportSchematics es;

        /**
         * Initialize the instance
         */
        construct
        {
            delete_event.connect(on_delete_event);

            // Setup actions

            add_action_entries(action_entries, this);

            m_project_widget.add_actions(this);

            m_actions = new CustomAction[]
            {
                new ExportBillOfMaterial(this),
                new ExportNetlist(this),
                new ExportSchematics(this)
            };

            foreach (var action in m_actions)
            {
                add_action(action.create_action());
            }

            // Setup drag and drop

            var targets = new Gtk.TargetList(null);
            targets.add_uri_targets(TargetInfo.URI_LIST);

            Gtk.drag_dest_set(
                this,
                Gtk.DestDefaults.ALL,
                target_entries,
                Gdk.DragAction.MOVE
                );

            Gtk.drag_dest_set_target_list(this, targets);

            drag_data_received.connect(on_data_received);

            // Setup project signal handling

            m_project_widget.open_files.connect(open);

            bind_property(
                "project",
                m_project_widget,
                "project",
                BindingFlags.SYNC_CREATE
                );

            // Setup notebook signal handling

            notebook.switch_page.connect(on_switch_page);

            // Setup library signal handling

            m_library_widget.open_files.connect(open);

            m_document_window_factory = new SchematicWindowFactory(
                m_library_widget
                );

            m_drawing_tools = new DrawingToolSet(m_complex_factory);

            add_property_editor(new ColorEditor());
            add_property_editor(new LineStyleEditor());
            add_property_editor(new FillStyleEditor());
            add_property_editor(new TextPropertyEditor());
            add_property_editor(new PinPropertyEditor());

            key_press_event.connect(on_key_press_event);
            key_release_event.connect(on_key_release_event);
        }


        /**
         * Construct the main window
         *
         * @param file the file to open in the new window
         */
        public MainWindow(File? file = null)
        {
            if (file != null)
            {
                open_project(file);
            }
        }


        /**
         * Close the current project
         *
         * Truth table for this function:
         *
         * project = the state of the project on entry
         * changed = changes made to project since last save
         * abort = user chose not to save the changes
         * dialog = the user response from the dialog
         * save = if the project is saved
         * output = the state of the project on exit
         *
         * |project|changed|dialog |save |output|
         * +-------+-------+-------+-----+------+
         * |closed |x      |x      |false|closed|
         * |open   |false  |x      |false|closed|
         * |open   |true   |save   |true |closed|
         * |open   |true   |discard|false|closed|
         * |open   |true   |cancel |false|open  |
         *
         * If the project is open after this function is called, then
         * operations such as project-new and project-open should
         * abort.
         */
        public void close_project()
        {
            if (project != null)
            {
                if (false) // if (project.changed)
                {
                    var dialog = new Gtk.MessageDialog(
                        this,
                        Gtk.DialogFlags.MODAL,
                        Gtk.MessageType.QUESTION,
                        Gtk.ButtonsType.NONE,
                        "Save changes?"
                        );

                    dialog.add_buttons(
                        "Save",    Gtk.ResponseType.YES,
                        "Discard", Gtk.ResponseType.NO,
                        "Cancel",  Gtk.ResponseType.CANCEL
                        );

                    var response = dialog.run();

                    if (response == Gtk.ResponseType.YES)
                    {
                        try
                        {
                            project.save();
                            project = null;
                        }
                        catch (Error error)
                        {
                            ErrorDialog.show_with_file(
                                this,
                                error,
                                project.file
                                );
                        }
                    }
                    else if (response == Gtk.ResponseType.NO)
                    {
                        project = null;
                    }

                    dialog.destroy();
                }
                else
                {
                    project = null;
                }
            }
        }


        /**
         * Open existing files
         *
         * This functions sets current notebook page to the page
         * containing last document succesfully opened.
         *
         * @param files the files to open
         */
        public void open(File[] files)

            requires (m_document_window_factory != null)
            requires (notebook != null)

        {
            Gtk.Widget? last_window = null;

            foreach (var file in files)
            {
                try
                {
                    var window = find_by_file(file);

                    if (window == null)
                    {
                        window = m_document_window_factory.create_with_file(
                            file
                            );

                        window.show_all();
                        var tab = new DocumentTab(window);
                        tab.show_all();

                        notebook.append_page(window, tab);
                    }

                    last_window = window;
                }
                catch (Error error)
                {
                    ErrorDialog.show_with_file(this, error, file);
                }
            }

            if (last_window != null)
            {
                var page_index = notebook.page_num(last_window);

                if (page_index >= 0)
                {
                    notebook.set_current_page(page_index);
                }
                else
                {
                    warn_if_reached();
                }
            }
        }


        /**
         * Open an existing project
         *
         * A current project that is open should be closed before
         * calling this function.
         *
         * @param file the project file to open
         */
        public void open_project(File file)

            requires(project == null)

        {
            try
            {
                var mapper = new Geda3.KeyFileProjectStorage.open(file);

                project = new Geda3.Project(mapper);
            }
            catch (Error error)
            {
                ErrorDialog.show_with_file(this, error, file);
            }
        }


        /**
         * The name of the program as it appears in the title bar
         */
        [CCode(cname = "PACKAGE_NAME")]
        private extern const string PROGRAM_TITLE;


        /**
         * The file extension for projects
         */
        private const string PROJECT_EXTENSION = ".project";


        /**
         * File filters used by the open project dialog
         */
        private static Gtk.FileFilter[] s_project_filters = create_project_filters();


        /**
         * Identifies the drop operation
         */
        private enum TargetInfo
        {
            URI_LIST,
            COUNT
        }


        /**
         * Organized from most frequently used to least frequently used
         */
        private const ActionEntry[] action_entries =
        {
            { "select-tool", on_select_tool, "s", "'select'", on_tool_change },
            { "zoom-extents", on_zoom_extents, null, null, null },
            { "zoom-in", on_zoom_in, null, null, null },
            { "zoom-out", on_zoom_out, null, null, null },
            { "edit-delete", on_edit_delete, null, null, null },
            { "edit-undo", on_edit_undo, null, null, null },
            { "edit-redo", on_edit_redo, null, null, null },
            { "edit-paste", on_edit_paste, null, null, null },
            { "edit-cut", on_edit_cut, null, null, null },
            { "edit-copy", on_edit_copy, null, null, null },
            { "edit-select-all", on_edit_select_all, null, null, null },
            { "edit-pins", on_edit_pins, null, null, null },
            { "file-save", on_file_save, null, null, null },
            { "file-save-all", on_file_save_all, null, null, null },
            { "file-save-as", on_file_save_as, null, null, null },
            { "file-open", on_file_open, null, null, null },
            { "file-new", on_file_new, null, null, null },
            { "file-reload", on_file_reload, null, null, null },
            { "project-save", on_project_save, null, null, null },
            { "project-open", on_project_open, null, null, null },
            { "project-new", on_project_new, null, null, null },
            { "select-grid", null, "s", "'mesh'", on_grid_change },
            { "view-reveal", null, null, "false", on_view_reveal_change }
        };


        /**
         * The drag and drop targets
         *
         * Currently, an empty list since drag_dest_set cannot accept
         * a null pointer.
         */
        private const Gtk.TargetEntry[] target_entries =
        {
        };


        /**
         * Actions for this ApplicationWindow
         */
        private CustomAction[] m_actions;


        private MainComplexFactory m_complex_factory;


        /**
         * The current document window
         */
        private DocumentWindow? m_current_document_window = null;


        /**
         * The drawing tools
         */
        private DrawingToolSet m_drawing_tools;


        /**
         * A list of the property editors that must be updated when
         * the current document window changes.
         */
        private Gee.List<ItemEditor> m_editors = new Gee.ArrayList<ItemEditor>();


        /**
         * A dialog box for opening new files
         */
        private Gtk.FileChooserDialog m_file_open_dialog = null;


        /**
         * The box containing property editors
         */
        [GtkChild(name="property-editor")]
        private Gtk.Box m_property_editor;


        /**
         * The notebook containing the document windows
         */
        [GtkChild]
        private Gtk.Notebook notebook;


        /**
         * The widget containing the library view
         */
        [GtkChild(name="library")]
        private LibraryWidget m_library_widget;


        /**
         * The widget containing the project view
         */
        [GtkChild(name="project")]
        private ProjectWidget m_project_widget;


        /**
         * The widget containing the attribute editor
         */
        [GtkChild(name="editor")]
        private AttributeEditor m_attribute_widget;


        /**
         *
         */
        private DocumentWindowFactory m_document_window_factory;


        /**
         * Add a property editor to the property editor widget
         *
         * @param editor The editor to add to the property editor
         */
        private void add_property_editor(ItemEditor editor)

            requires(m_editors != null)
            requires(m_property_editor != null)

        {
            editor.update_document_window(m_current_document_window);
            m_editors.add(editor);
            m_property_editor.add(editor);
        }


        /**
         * Create the file filters used by the open project
         */
        private static Gtk.FileFilter[] create_project_filters()
        {
            var filters = new Gee.ArrayList<Gtk.FileFilter>();

            var all = new Gtk.FileFilter();
            all.set_filter_name("All Files");
            all.add_pattern("*.*");
            filters.add(all);

            var projects = new Gtk.FileFilter();
            projects.set_filter_name("Projects");
            projects.add_pattern(@"*$PROJECT_EXTENSION");
            filters.add(projects);

            return filters.to_array();
        }


        /**
         * Gets the current page in the notebook
         *
         * @return The current page in the notebook. If the notebook
         * does not have a current page, then this fucntion returns
         * null.
         */
        private Gtk.Widget? get_current_page()

            requires(notebook != null)

        {
            Gtk.Widget? page = null;
            var page_index = notebook.get_current_page();

            if (page_index >= 0)
            {
                page = notebook.get_nth_page(page_index) as SchematicWindow;
            }

            return page;
        }
        

        /**
         * Find the document window that contains a file
         *
         * @param file The file to search for
         * @return The document window containing the file, or null if
         * not found.
         */
        private DocumentWindow? find_by_file(File file) throws Error

            requires(notebook != null)

        {
            var file_info = file.query_info(
                FileAttribute.ID_FILE,
                FileQueryInfoFlags.NONE
                );

            var file_id = file_info.get_attribute_string(
                FileAttribute.ID_FILE
                );

            if (file_id == null)
            {
                return null;
            }

            var page_count = notebook.get_n_pages();

            for (var page_index = 0; page_index < page_count; page_index++)
            {
                var window = notebook.get_nth_page(page_index) as DocumentWindow;

                if (window == null)
                {
                    continue;
                }

                var fileable = window as Fileable;

                if (fileable == null)
                {
                    continue;
                }

                if (file_id == fileable.file_id)
                {
                    return window;
                }
            }

            return null;
        }


        /**
         *
         *
         * @param event
         */
        private bool on_key_press_event(Gtk.Widget widget, Gdk.EventKey event)

            requires(event.type == Gdk.EventType.KEY_PRESS)
            requires(m_drawing_tools != null)
            requires(widget == this)

        {
            return m_drawing_tools.key_pressed(event);
        }


        /**
         *
         *
         * @param event
         */
        private bool on_key_release_event(Gtk.Widget widget, Gdk.EventKey event)

            requires(event.type == Gdk.EventType.KEY_RELEASE)
            requires(m_drawing_tools != null)
            requires(widget == this)

        {
            return m_drawing_tools.key_released(event);
        }


        /**
         * An event handler for drag and drop data received
         *
         * @param context the drag context
         * @param x the x coordinate of the drop location
         * @param y the y coordinate of the drop location
         * @param data the selection data
         * @param info the number registered in the target list
         * @param timestamp when the drop operation occured
         */
        private void on_data_received(
            Gdk.DragContext context,
            int x,
            int y,
            Gtk.SelectionData data,
            uint info,
            uint timestamp
            )

            requires (info < TargetInfo.COUNT)

        {
            if (info == TargetInfo.URI_LIST)
            {
                var files = new Gee.ArrayList<File>();
                var uris = data.get_uris();

                foreach (var uri in uris)
                {
                    files.add(File.new_for_uri(uri));
                }

                open(files.to_array());
            }
        }


        /**
         * An event handler when the user selects the delete button
         *
         * @return true Abort the destruction process
         * @return false Continue with the destruction process
         */
        private bool on_delete_event(Gdk.EventAny event)
        {
            return false;
        }


        /**
         * Copy the selection to the clipboard
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_copy(SimpleAction action, Variant? parameter)
        {
            try
            {
                var clipboard = Gtk.Clipboard.@get(
                    Gdk.SELECTION_CLIPBOARD
                    );

                var support = m_current_document_window as ClipboardSupport;
                return_if_fail(support != null);

                support.copy(clipboard);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * Move the selection the clipboard
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_cut(SimpleAction action, Variant? parameter)
        {
            try
            {
                var clipboard = Gtk.Clipboard.@get(
                    Gdk.SELECTION_CLIPBOARD
                    );

                var support = m_current_document_window as ClipboardSupport;
                return_if_fail(support != null);

                support.cut(clipboard);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * Delete the selection
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_delete(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_edit_delete\n");
        }


        /**
         * Paste from the clipboard
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_paste(SimpleAction action, Variant? parameter)
        {
            try
            {
                var clipboard = Gtk.Clipboard.@get(
                    Gdk.SELECTION_CLIPBOARD
                    );

                var support = m_current_document_window as ClipboardSupport;
                return_if_fail(support != null);

                support.paste(clipboard);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_pins(SimpleAction action, Variant? parameter)
        {
            var dialog = new PinEditorDialog();

            dialog.set_transient_for(this);
            dialog.update_document_window(m_current_document_window);

            var response = dialog.run();

            dialog.destroy();
        }


        /**
         * Redo the last undo
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_redo(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_edit_redo\n");
        }


        /**
         * Select all in the document
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_select_all(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_edit_select_all\n");
        }


        /**
         * Undo the last action
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_edit_undo(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_edit_undo\n");
        }


        /**
         * Create a new file
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_new(SimpleAction action, Variant? parameter)

            requires (m_document_window_factory != null)
            requires(notebook != null)

        {
            var window = m_document_window_factory.create();

            window.show_all();
            var tab = new DocumentTab(window);
            tab.show_all();

            notebook.append_page(window, tab);
        }


        /**
         * Open existing file(s)
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_open(SimpleAction action, Variant? parameter)
        {
            if (m_file_open_dialog == null)
            {
                stdout.printf("Creating\n");
                
                m_file_open_dialog = new Gtk.FileChooserDialog(
                    "Select File",
                    this,
                    Gtk.FileChooserAction.OPEN,
                    "_Cancel", Gtk.ResponseType.CANCEL,
                    "_Open", Gtk.ResponseType.ACCEPT
                    );

                m_file_open_dialog.select_multiple = true;
            }

            var folder = m_file_open_dialog.get_current_folder();

            stdout.printf(@"In... $folder\n");

            var response = m_file_open_dialog.run();

            if (response == Gtk.ResponseType.ACCEPT)
            {
                var files = new Gee.ArrayList<File>();

                m_file_open_dialog.get_files().foreach(
                    (file) => { files.add(file); }
                    );

                open(files.to_array());
            }

            m_file_open_dialog.hide();

            folder = m_file_open_dialog.get_current_folder();
            stdout.printf(@"Out... $folder\n");
        }


        /**
         * Reload the current file
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_reload(SimpleAction action, Variant? parameter)

            requires(notebook != null)

        {
            var page = get_current_page() as SchematicWindow;

            if (page != null)
            {
                try
                {
                    page.reload(this);
                }
                catch (Error error)
                {
                    ErrorDialog.show_with_file(this, error, page.file);
                }
            }
        }


        /**
         * Save the current file
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save(SimpleAction action, Variant? parameter)

            requires(notebook != null)

        {
            var page = get_current_page() as SchematicWindow;

            if (page != null)
            {
                try
                {
                    page.save(this);
                }
                catch (Error error)
                {
                    ErrorDialog.show_with_file(this, error, page.file);
                }
            }
        }


        /**
         * Save all the open files
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save_all(SimpleAction action, Variant? parameter)

            requires(notebook != null)

        {
            if (project != null)
            {
                try
                {
                    project.save();
                }
                catch (Error error)
                {
                    ErrorDialog.show_with_file(this, error, project.file);
                }
            }

            var page_count = notebook.get_n_pages();

            for (var page_index = 0; page_index < page_count; page_index++)
            {
                var page = notebook.get_nth_page(page_index) as Savable;

                if (page != null)
                {
                    try
                    {
                        page.save(this);
                    }
                    catch (Error error)
                    {
                        ErrorDialog.show_with_file(this, error, page.file);
                    }
                }
            }
        }


        /**
         * Save the current file with a different filename
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save_as(SimpleAction action, Variant? parameter)
        {
            var page = get_current_page() as SchematicWindow;

            if (page != null)
            {
                try
                {
                    page.save_as(this);
                }
                catch (Error error)
                {
                    ErrorDialog.show_with_file(this, error, page.file);
                }
            }
        }


        /**
         * Signal handler when the user changes the drawing tool
         *
         * @param action the action that activated this function call
         * @param parameter The name of the tool as a string
         */
        private void on_grid_change(SimpleAction action, Variant? state)

            requires(notebook != null)
            requires(state != null)
            requires(state.is_of_type(VariantType.STRING))

        {
            var name = state.get_string();

            return_if_fail(name != null);

            // Since a signal handler was added to the change_state
            // signal, this function is responsibe for setting the
            // state of the action.

            action.set_state(state);

            var page = get_current_page() as SchematicWindow;

            if (page != null)
            {
                page.select_grid(name);
            }
        }


        /**
         * Create a new project and set it as the current project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_project_new(SimpleAction action, Variant? parameter)
        {
            close_project();

            if (project == null)
            {
                var dialog = new NewProjectDialog();

                dialog.set_transient_for(this);

                var response = dialog.run();

                if (response == Gtk.ResponseType.ACCEPT)
                {
                    //var file = dialog.get_file();

                    //project = new Geda3.KeyFileProject.create(file);
                }

                dialog.destroy();
            }
        }


        /**
         * Open an existing project and set it as the current project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_project_open(SimpleAction action, Variant? parameter)
        {
            close_project();

            if (project == null)
            {
                var dialog = new Gtk.FileChooserDialog(
                    "Select File",
                    this,
                    Gtk.FileChooserAction.OPEN,
                    "_Cancel", Gtk.ResponseType.CANCEL,
                    "_Open", Gtk.ResponseType.ACCEPT
                    );

                foreach (var filter in s_project_filters)
                {
                    dialog.add_filter(filter);
                }

                var response = dialog.run();

                if (response == Gtk.ResponseType.ACCEPT)
                {
                    var file = dialog.get_file();

                    open_project(file);
                }

                dialog.destroy();
            }
        }


        /**
         * Save the current project
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_project_save(SimpleAction action, Variant? parameter)

            requires(project != null)

        {
            //warn_if_fail(can_project_save);

            try
            {
                project.save();
            }
            catch (Error error)
            {
                ErrorDialog.show_with_file(this, error, project.file);
            }
        }


        /**
         * Select a drawing tool
         *
         * Default functionality in the SimpleAction provides the same
         * functionality as this method. This method is kept for
         * precondition checks to validate the parameter and state for
         * the action.
         *
         * @param action the action that activated this function call
         * @param parameter The name of the tool as a string
         */
        private void on_select_tool(SimpleAction action, Variant? parameter)

            requires(action.state.is_of_type(VariantType.STRING))
            requires(action.state_type != null)
            requires(action.state_type.equal(VariantType.STRING))
            requires(parameter != null)
            requires(parameter.is_of_type(VariantType.STRING))

        {
            // Since a signal handler has been connected to the
            // activate signal, the signal handler is responsible for
            // changing the state.

            action.change_state(parameter);
        }


        /**
         * Signal handler for notebook page changes
         *
         * @param page The widget representing the page
         * @param number The page number
         */
        private void on_switch_page(Gtk.Widget page, uint number)

            requires (notebook != null)

        {
            var selectable = page as SchematicWindow;

            if (selectable == null)
            {
                // needs to disable the action
            }
            else
            {
                // needs to enable the action
            }

            m_current_document_window = page as DocumentWindow;

            m_drawing_tools.update_document_window(
                m_current_document_window
                );

            m_attribute_widget.update_document_window(
                m_current_document_window
                );

            foreach (var editor in m_editors)
            {
                editor.update_document_window(
                    m_current_document_window
                    );
            }
        }


        /**
         * Signal handler when the user changes the drawing tool
         *
         * @param action the action that activated this function call
         * @param state The name of the tool as a string
         */
        private void on_tool_change(SimpleAction action, Variant? state)

            requires(m_drawing_tools != null)
            requires(state != null)
            requires(state.is_of_type(VariantType.STRING))

        {
            var next_tool = state.get_string();

            return_if_fail(next_tool != null);

            // Since a signal handler was added to the change_state
            // signal, this function is responsibe for setting the
            // state of the action.

            action.set_state(state);

            m_drawing_tools.select_tool(next_tool);
        }


        /**
         * Reveal hidden items on schematics
         *
         * @param action the action that activated this function call
         * @param state The boolean state of the action
         */
        private void on_view_reveal_change(SimpleAction action, Variant? state)

            requires(state != null)
            requires(state.is_of_type(VariantType.BOOLEAN))

        {
            var settings = SchematicWindowSettings.get_default();

            return_if_fail(settings != null);

            settings.reveal = state.get_boolean();

            // Since a signal handler was added to the change_state
            // signal, this function is responsibe for setting the
            // state of the action.

            action.set_state(state);
        }


        /**
         * Zoom the current view to the extents
         *
         * The associated action for this method should be disabled
         * when the notebook does not have a current page, or the page
         * does not support this action. So, it is considered a logic
         * error to call this method without current page that can
         * accept this action.
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_zoom_extents(SimpleAction action, Variant? parameter)
        {
            var page = get_current_page() as Zoomable;

            return_if_fail(page != null);

            page.zoom_extents();
        }


        /**
         * Zoom in on the center of the current view
         *
         * The associated action for this method should be disabled
         * when the notebook does not have a current page, or the page
         * does not support this action. So, it is considered a logic
         * error to call this method without current page that can
         * accept this action.
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_zoom_in(SimpleAction action, Variant? parameter)
        {
            var page = get_current_page() as Zoomable;

            return_if_fail(page != null);

            page.zoom_in_center();
        }


        /**
         * Zoom out on the center of the current view
         *
         * The associated action for this method should be disabled
         * when the notebook does not have a current page, or the page
         * does not support this action. So, it is considered a logic
         * error to call this method without current page that can
         * accept this action.
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_zoom_out(SimpleAction action, Variant? parameter)
        {
            var page = get_current_page() as Zoomable;

            return_if_fail(page != null);

            page.zoom_out_center();
        }
    }
}
